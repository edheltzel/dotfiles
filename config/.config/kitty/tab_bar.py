"""Custom kitty tab bar with right-aligned status area.

Renders pill-shaped tabs via draw_tab_with_powerline() and appends a
right-aligned active-process strip after the last tab.
"""

import os
import subprocess
import time
from collections import deque

from kitty.fast_data_types import Color, Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    color_as_sgr,
    draw_tab_with_powerline,
)
from kitty.boss import get_boss

# ---------------------------------------------------------------------------
# Eldritch palette
# ---------------------------------------------------------------------------
_CLR_BG = "#171928"  # background
_CLR_TAB_BG = "#212337"  # inactive tab bg
_CLR_CYAN = "#04D1F9"  # process segment
_CLR_ORANGE = "#F7C67F"  # claude
_CLR_BLUE = "#9071F4"  # pi
_CLR_PINK = "#F265B5"  # omp
_CLR_MUTED = "#7081D0"  # separators / dim text


def _color(hex_color: str) -> int:
    """Convert a hex colour string like '#F265B5' to a kitty colour int."""
    hex_color = hex_color.lstrip("#")
    r = int(hex_color[0:2], 16)
    g = int(hex_color[2:4], 16)
    b = int(hex_color[4:6], 16)
    return as_rgb((r << 16) | (g << 8) | b)


# Pre-compute colour ints once at module load.
CLR_BG = _color(_CLR_BG)
CLR_TAB_BG = _color(_CLR_TAB_BG)
CLR_CYAN = _color(_CLR_CYAN)
CLR_ORANGE = _color(_CLR_ORANGE)
CLR_BLUE = _color(_CLR_BLUE)
CLR_PINK = _color(_CLR_PINK)
CLR_MUTED = _color(_CLR_MUTED)

# ---------------------------------------------------------------------------
# Process icon mapping (Nerd Font glyphs)
# ---------------------------------------------------------------------------
PROCESS_ICONS: dict[str, str] = {
    "nvim": "\ue62b",  # custom_vim
    "vim": "\ue62b",
    "fish": "\uee41",
    "bash": "\ue795",  # dev_terminal
    "zsh": "\ue795",
    "git": "\ue725",  # dev_git
    "node": "\U000f0399",  # md_nodejs
    "python": "\ue73c",  # dev_python
    "python3": "\ue73c",
    "ruby": "\ue739",  # dev_ruby
    "bun": "\U000f0399",  # md_nodejs (bun is JS runtime)
    "docker": "\uf308",  # dev_docker
    "ssh": "\uf489",  # fa_terminal
    "cargo": "\ue7a8",  # dev_rust
    "make": "\U000f0218",  # md_cogs
    "lazygit": "\ue725",  # dev_git
    "yazi": "\U000f024b",  # md_folder
    "claude": "\uec82",
    "codex": "\uec81",
    "pi": "\ue22c",
    "omp": "\U000f03ff",
    "jcode": "\U000f0af7",
    "grok": "\U000f06a9",
    "opencode": "\U000f06a9",
    "prime-agent": "\U000f06a9",
    "herdr": "\U000f0cc6",
}
DEFAULT_ICON = "\uf489"  # fa_terminal fallback
ACTIVITY_ICON = "⚡︎"
_INTERPRETERS = frozenset({"node", "nodejs", "python", "python3", "bun", "ruby"})
_HARNESSES = frozenset({
    "claude", "codex", "pi", "omp", "jcode", "grok", "opencode", "prime-agent", "herdr",
})
_HARNESS_ALIASES = {"claude-code": "claude", "claude_code": "claude"}
PROCESS_COLORS: dict[str, int] = {
    "claude": CLR_ORANGE,
    "pi": CLR_BLUE,
    "omp": CLR_PINK,
}
_PS: tuple[float, dict[int, tuple[int, str]]] = (0.0, {})


def _hex_color(h: str) -> Color:
    h = h.lstrip("#")
    return Color(int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16))


ICON_COLORS = {
    "claude": _hex_color("#F7C67F"),
    "pi": _hex_color("#9071F4"),
    "omp": _hex_color("#F265B5"),
}


def _sgr_fg(color: Color) -> str:
    return f"\x1b[38{color_as_sgr(color)}m"


# ---------------------------------------------------------------------------
# Active-window data helper
# ---------------------------------------------------------------------------


def _basename(token: str) -> str:
    base = os.path.basename(token)
    return base[1:] if base.startswith("-") else base


def _norm(token: str) -> str:
    return _basename(token).lower()


def _harness_from_token(token: str) -> str:
    for part in token.replace("\\", "/").split("/"):
        name = _norm(part).rsplit(".", 1)[0]
        if name in _HARNESS_ALIASES:
            return _HARNESS_ALIASES[name]
        if name in PROCESS_ICONS:
            return name
    return ""


def _proc_from_cmdline(cmdline: list[str]) -> str:
    if not cmdline:
        return ""
    cmd = _norm(cmdline[0])
    if cmd in _INTERPRETERS:
        for arg in cmdline[1:]:
            if not arg or arg.startswith("-"):
                continue
            found = _harness_from_token(arg)
            if found:
                return found
    return cmd


def _harness_from_comms(comms: list[str]) -> str:
    for comm in comms:
        name = _norm(comm)
        if name in _HARNESS_ALIASES:
            name = _HARNESS_ALIASES[name]
        if name in _HARNESSES:
            return name
    return ""


def _ps_table() -> dict[int, tuple[int, str]]:
    global _PS
    now = time.monotonic()
    ts, table = _PS
    if now - ts < 1.0 and table:
        return table
    table = {}
    try:
        out = subprocess.check_output(
            ["ps", "-ax", "-o", "pid=,ppid=,comm="],
            text=True,
            timeout=0.5,
        )
    except (OSError, subprocess.SubprocessError):
        return _PS[1]
    for line in out.splitlines():
        parts = line.split(None, 2)
        if len(parts) < 2:
            continue
        try:
            table[int(parts[0])] = (
                int(parts[1]),
                parts[2].strip() if len(parts) > 2 else "",
            )
        except ValueError:
            continue
    _PS = (now, table)
    return table


def _harness_in_session(root_pid: int) -> str:
    if not root_pid:
        return ""
    table = _ps_table()
    kids: dict[int, list[tuple[int, str]]] = {}
    for pid, (ppid, comm) in table.items():
        kids.setdefault(ppid, []).append((pid, comm))
    comms: list[str] = []
    seen: set[int] = set()
    q = deque([root_pid])
    while q:
        pid = q.popleft()
        if pid in seen:
            continue
        seen.add(pid)
        for cpid, comm in kids.get(pid, []):
            comms.append(comm)
            q.append(cpid)
    return _harness_from_comms(comms)


def _window_cmdline(w) -> list[str]:
    if w is None:
        return []
    fps = getattr(getattr(w, "child", None), "foreground_processes", None) or []
    first: list[str] = []
    harness_cmd: list[str] = []
    for p in fps:
        cmd = list(p.get("cmdline") or [])
        if not cmd:
            continue
        if not first:
            first = cmd
        name = _proc_from_cmdline(cmd)
        if name in _HARNESSES:
            harness_cmd = cmd
            break
    if harness_cmd:
        return harness_cmd
    if first:
        return first
    exe = w.get_exe_of_child() or ""
    return [exe] if exe else []


def _shell_pid(w) -> int:
    if w is None:
        return 0
    pid = getattr(w, "pid", 0) or 0
    if pid:
        return int(pid)
    child = getattr(w, "child", None)
    return int(getattr(child, "pid", 0) or 0)


def _proc_name(w, tab_data=None) -> str:
    cmdline = _window_cmdline(w)
    if not cmdline and tab_data is not None:
        exe = getattr(tab_data, "active_exe", "") or ""
        if exe:
            cmdline = [exe]
    name = _proc_from_cmdline(cmdline)
    session = _harness_in_session(_shell_pid(w))
    if session:
        return session
    return name


def _is_active_tab(tab_id: int) -> bool:
    boss = get_boss()
    if boss is None:
        return False
    for tm in boss.all_tab_managers:
        t = tm.tab_for_id(tab_id)
        if t is not None:
            return tm.active_tab is t
    return False


def _get_active_process() -> str:
    """Return the active window's process basename, non-blocking."""
    boss = get_boss()
    if boss is None:
        return ""
    tab = boss.active_tab
    if tab is None:
        return ""
    return _proc_name(tab.active_window)


def _draw_status_area(screen: Screen) -> None:
    """Draw the active-process strip right-aligned."""
    proc_name = _get_active_process()
    if not proc_name:
        return
    text = f" {PROCESS_ICONS.get(proc_name, DEFAULT_ICON)} {proc_name} "
    target_x = screen.columns - len(text)
    if target_x <= screen.cursor.x:
        return
    screen.cursor.bg = CLR_BG
    screen.cursor.fg = CLR_MUTED
    screen.draw(" " * (target_x - screen.cursor.x))
    screen.cursor.fg = PROCESS_COLORS.get(proc_name, CLR_CYAN)
    screen.draw(text)



# ---------------------------------------------------------------------------
# Tab title: set_tab_title name if set, else project directory basename
# ---------------------------------------------------------------------------


def draw_title(data: dict) -> str:
    tab = get_boss().tab_for_id(data["tab_id"])
    tab_data = data.get("tab")
    w = tab.active_window if tab else None
    exe = _proc_name(w, tab_data)
    if exe == "herdr" or exe.startswith("herdr"):
        icon = "🐏"
    else:
        icon = PROCESS_ICONS.get(exe, ACTIVITY_ICON)
    wd = os.path.basename((getattr(tab_data, "active_wd", "") or "").rstrip(os.sep))
    tab_id = data["tab_id"]
    if not _is_active_tab(tab_id):
        return f"{icon} {wd}" if wd else icon
    if tab and getattr(tab, "name", ""):
        title = tab.name
    elif exe == "herdr" or exe.startswith("herdr"):
        return "🐏 Herdr"
    else:
        title = wd
    icon_color = ICON_COLORS.get(exe)
    tab_sgr = getattr(getattr(data.get("fmt"), "fg", None), "tab", None)
    if icon and icon_color is not None and isinstance(tab_sgr, str):
        icon = f"{_sgr_fg(icon_color)}{icon}{tab_sgr}"
    return f"{icon} {title}" if icon else title

# ---------------------------------------------------------------------------
# Main entry point called by kitty for every tab
# ---------------------------------------------------------------------------


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    """Render one tab, and — if it is the last — append the status area."""
    end = draw_tab_with_powerline(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    if is_last and not extra_data.for_layout:
        _draw_status_area(screen)
    return end


if __name__ == "__main__":
    assert _proc_from_cmdline(["node", "/path/to/omp"]) == "omp"
    assert _proc_from_cmdline(["echo", "codex"]) == "echo"
    assert _proc_from_cmdline(["-fish"]) == "fish"
    assert _harness_from_comms(["node", "claude", "fish"]) == "claude"
    assert _harness_from_comms(["node", "fish"]) == ""
    assert _harness_from_comms(["codegraph", "node"]) == ""
    icon_seq = _sgr_fg(ICON_COLORS["omp"])
    restore_seq = _sgr_fg(_hex_color("#37F499"))
    assert icon_seq.startswith("\x1b[38")
    scr = Screen()
    scr.apply_sgr(icon_seq[2:-1])
    icon_fg = scr.cursor.fg
    scr.apply_sgr(restore_seq[2:-1])
    title_fg = scr.cursor.fg
    assert icon_fg != 0 and title_fg != 0 and icon_fg != title_fg
    miss = Screen()
    miss.apply_sgr(color_as_sgr(ICON_COLORS["omp"]))
    assert miss.cursor.fg == 0
