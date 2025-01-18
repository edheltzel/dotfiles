local map = vim.keymap.set

-- general mappings
map("n", "<C-s>", "<cmd> w <CR>")
map("n", "<C-c>", "<cmd> %y+ <CR>") -- copy whole filecontent

map("n", "J", "mzJ`z", { desc = "Join lines" })
map("x", "<leader>p", '"_dP', { desc = "Paste and delete selection into void register" }) -- greatest remap ever

map("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

map(
	"n",
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace all occurences of word under cursor" }
)
-- buffer management
map("n", "<leader>]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bf", "<cmd>bfirst<CR>", { desc = "First buffer" })
map("n", "<leader>bl", "<cmd>blast<CR>", { desc = "Last buffer" })
map("n", "<C-q>", "<cmd>confirm q<CR>", { desc = "Quit window" })
map("n", "<C-Q>", "<cmd>q!<CR>", { desc = "Force quit" })
map("n", "<leader>q", "<cmd>confirm qall<CR>", { desc = "Quit" })

-- alternate file switching
map("n", "<Tab>", "<C-^>", { desc = "Switch to alternate file" })
map("n", "<BS>", "<cmd>vsplit #<CR>", { desc = "Open alternate file in split" })

-- LSP mappings
map("n", "gD", function()
	vim.lsp.buf.declaration()
end, { desc = "Declaration of current symbol" })
map("n", "gd", function()
	vim.lsp.buf.definition()
end, { desc = "Definition of current symbol" })
