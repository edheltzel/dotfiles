"""Custom kitty tab bar with right-aligned status area.

Renders pill-shaped tabs via draw_tab_with_powerline() and appends a
right-aligned active-process strip after the last tab.
"""

import os

from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
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
    "fish": "\U000f0f31",  # md_fish
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
    "herdr": "\U000f06a9",
}
DEFAULT_ICON = "\uf489"  # fa_terminal fallback
PROCESS_COLORS: dict[str, int] = {
    "claude": CLR_ORANGE,
    "pi": CLR_BLUE,
    "omp": CLR_PINK,
}


# ---------------------------------------------------------------------------
# Active-window data helper
# ---------------------------------------------------------------------------


def _get_active_process() -> str:
    """Return the active window's process basename, non-blocking."""
    boss = get_boss()
    if boss is None:
        return ""
    tab = boss.active_tab
    if tab is None:
        return ""
    w = tab.active_window
    if w is None:
        return ""
    return os.path.basename(w.get_exe_of_child() or "")


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
    if tab and tab.name:
        return tab.name
    tab_data = data.get("tab")
    active_exe = getattr(tab_data, "active_exe", "") or ""
    if active_exe == "herdr" or active_exe.startswith("herdr"):
        return "🐏 Herdr"
    wd = getattr(tab_data, "active_wd", "") or ""
    return os.path.basename(wd.rstrip(os.sep)) or wd

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
