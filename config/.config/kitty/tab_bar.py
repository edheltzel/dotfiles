"""Custom kitty tab bar with right-aligned status area.

Renders pill-shaped tabs via draw_tab_with_powerline() and appends a
right-aligned status strip (CWD, git branch, active process) after the
last tab.  Uses the Eldritch colour palette throughout.

IMPORTANT: subprocess.run is NEVER called inside draw_tab().  Git branch
data lives in a module-level cache that a 2-second kitty timer refreshes
in the background.
"""

import os
import subprocess

from kitty.fast_data_types import Screen, add_timer
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
_CLR_PINK = "#F265B5"  # cwd segment
_CLR_PURPLE = "#A48CF2"  # git segment
_CLR_CYAN = "#04D1F9"  # process segment
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
CLR_PINK = _color(_CLR_PINK)
CLR_PURPLE = _color(_CLR_PURPLE)
CLR_CYAN = _color(_CLR_CYAN)
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
}
DEFAULT_ICON = "\uf489"  # fa_terminal fallback

# ---------------------------------------------------------------------------
# Git branch cache + timer
# ---------------------------------------------------------------------------
_git_cache: dict[str, str] = {}
_timer_id = None


def _get_git_branch(cwd: str) -> str:
    """Return cached git branch for *cwd*, populating on first miss."""
    if not cwd:
        return ""
    if cwd not in _git_cache:
        try:
            result = subprocess.run(
                ["git", "branch", "--show-current"],
                cwd=cwd,
                capture_output=True,
                text=True,
                timeout=0.1,
            )
            _git_cache[cwd] = (
                result.stdout.strip() if result.returncode == 0 else ""
            )
        except Exception:
            _git_cache[cwd] = ""
    return _git_cache[cwd]


def _refresh_git_cache(timer_id: int) -> None:
    """Invalidate the git cache so the next draw picks up any new branch."""
    _git_cache.clear()


def _start_timer() -> None:
    """Register the 2-second repeating timer exactly once."""
    global _timer_id
    if _timer_id is None:
        _timer_id = add_timer(_refresh_git_cache, 2.0, True)


# Kick off the timer at module load time.
_start_timer()

# ---------------------------------------------------------------------------
# Active-window data helper
# ---------------------------------------------------------------------------


def _get_active_window_data() -> tuple[str, str]:
    """Return (cwd, process_name) for the active window, non-blocking."""
    boss = get_boss()
    if boss is None:
        return "", ""
    tab = boss.active_tab
    if tab is None:
        return "", ""
    w = tab.active_window
    if w is None:
        return "", ""
    cwd = w.cwd_of_child or ""
    procs = w.child.foreground_processes
    exe = procs[0]["cmdline"][0] if procs else ""
    return cwd, os.path.basename(exe)


# ---------------------------------------------------------------------------
# Status area drawing (right-aligned, called only for the last tab)
# ---------------------------------------------------------------------------


def _draw_status_area(screen: Screen) -> None:
    """Draw the CWD / git-branch / process status strip right-aligned."""
    cwd, proc_name = _get_active_window_data()
    cwd_basename = os.path.basename(cwd) if cwd else ""
    branch = _get_git_branch(cwd)
    proc_icon = PROCESS_ICONS.get(proc_name, DEFAULT_ICON)

    # Build individual segments (only include non-empty ones).
    segments: list[tuple[int, str]] = []
    if cwd_basename:
        segments.append((CLR_PINK, f" \uf07c {cwd_basename} "))
    if branch:
        segments.append((CLR_PURPLE, f" \ue725 {branch} "))
    if proc_name:
        segments.append((CLR_CYAN, f" {proc_icon} {proc_name} "))

    if not segments:
        return

    # Separator between segments.
    sep = " "

    # Calculate total visible width.
    total_len = sum(len(s[1]) for s in segments) + len(sep) * (len(segments) - 1)

    # Position cursor right-aligned.
    target_x = screen.columns - total_len
    if target_x <= screen.cursor.x:
        return  # not enough room

    # Fill the gap between last tab and the status area with background.
    screen.cursor.bg = CLR_BG
    screen.cursor.fg = CLR_MUTED
    gap = target_x - screen.cursor.x
    screen.draw(" " * gap)

    # Draw each segment.
    for i, (color, text) in enumerate(segments):
        screen.cursor.fg = color
        screen.cursor.bg = CLR_BG
        screen.draw(text)
        if i < len(segments) - 1:
            screen.cursor.fg = CLR_MUTED
            screen.draw(sep)


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
