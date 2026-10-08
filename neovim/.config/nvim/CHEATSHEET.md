# NOE.ED Quick Reference Cheatsheet

### Mode Exit

```
jk              Exit INSERT mode
<Esc>           Exit terminal / clear cursors
```

### Navigation

```
gh              Start of line (^)
gl              End of line ($)
<C-h/j/k/l>     Navigate splits
<leader>jj      Flash jump
```

### Line Operations

```
<A-j> / <A-down>     Move line down
<A-k> / <A-up>       Move line up
<A-S-j>              Duplicate line down
<A-S-k>              Duplicate line up
<A-S-d>              Duplicate line down
```

### Editing

```
U                    Redo
<Enter>              Toggle fold
> / <                Indent right/left
<C-]> / <C-[>        Indent right/left
<A-BS>               Delete word (alt-backspace)
<leader>d            Delete without yanking
<leader>nh           Clear search highlights
```

### Multi-Cursor

```
<C-S-l>              Add cursor to ALL matches
<C-A-down>           Add cursor at next match
<C-A-up>             Add cursor at prev match
<C-down>             Skip next match
<C-up>               Skip prev match
<C-leftmouse>        Add/remove cursor
<C-q>                Toggle cursor
<left>/<right>       Select different cursor
<leader>x            Delete current cursor
<Esc>                Clear all cursors
```

### Files & Projects

```
<leader>fs           Save file
<leader>fS           Save without formatting
<leader>ff           Find file
<leader>fg           Live grep
<leader>fp           Find projects (like VSCode Project Manager)
```

### Windows/Splits

```
<C-h/j/k/l>          Navigate splits
<leader>wh/j/k/l     Navigate splits (alt)
```

### Terminal

```
<C-`>                Toggle terminal
<Esc>                Exit terminal mode
```

### Git

```
<leader>gg           Lazygit (borderless)
<leader>gb           GitButler TUI (borderless)
<leader>gh           GitHub Dash (rounded float)
```

### macOS Cmd Keys (requires CSI u protocol)

```
<D-c>                Copy (word in normal, selection in visual)
<D-v>                Paste
<D-x>                Cut (word in normal, selection in visual)
<D-s>                Save file
<D-z>                Undo
<D-S-z>              Redo
<D-a>                Select all
```

### LSP

```
<leader>ih           Toggle inlay hints
gd                   Go to definition
gD                   Go to source definition (TS)
gR                   File references (TS)
K                    Hover documentation
```

### TypeScript

```
<leader>co           Organize imports
<leader>cM           Add missing imports
<leader>cu           Remove unused imports
<leader>cD           Fix all diagnostics
<leader>cV           Select TS version
```

### Python

```
<leader>co           Organize imports
<leader>vs           Select venv        ⚠ shares <leader>v with Vite+
<leader>vc           Cached venv        ⚠ collides with Vite+ check
<leader>dPt          Debug method
<leader>dPc          Debug class
```

### Vite+ (`<leader>v`)

Formatting on save uses `vp fmt` (Oxfmt); linting is the live Oxlint LSP.
These keymaps drive the `vp` CLI in a terminal:

```
<leader>vv           Command picker
<leader>vd           Dev server
<leader>vc           Check (fmt + lint + types)   ⚠ collides with Python "Cached venv"
<leader>vC           Check --fix
<leader>vl           Lint
<leader>vL           Lint --fix
<leader>vf           Format (vp fmt)
<leader>vt           Test
<leader>vT           Test --watch
<leader>vb           Build
<leader>vp           Preview
<leader>vr           Run task (prompt)
<leader>vi           Install deps
```

### Dashboard Shortcuts

```
N    New file
r    Recent files
f    Find file
g    Find text
o    Sessions
d    Dotfiles
v    NOE.ED config
n    FieldNotes
x    Lazy Extras
l    Lazy
q    Quit
```

### Plugin Management

```
:Lazy                Open Lazy.nvim
:Mason               Open Mason (LSP installer)
:LazyExtras          Toggle language packs
```
