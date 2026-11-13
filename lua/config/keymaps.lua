local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })
map({ "n", "i" }, "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlight" })
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })

-- Buffer controls under <leader>b
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bx", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bo", "<cmd>%bdelete|edit #|bdelete #<CR>", { desc = "Close other buffers" })
map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to last buffer" })

-- LSP (Neovim 0.11+ also provides grn, gra, grr, gri, K)
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gI", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Move lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Disable arrow keys to practice hjkl
for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
  map({ "n", "x", "o" }, key, "<Nop>", { desc = "Use hjkl" })
end
