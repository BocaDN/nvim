-- Set leaders
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Clear search highlight
keymap.set("n", "<leader><leader>", ":noh<CR>", opts)

-- Resize with arrows
keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
keymap.set("n", "<leader>bp", vim.cmd.bp, opts)
keymap.set("n", "<leader>bn", vim.cmd.bn, opts)

-- Basic file commands
keymap.set("n", "<leader>wq", ":wq<CR>", opts)
keymap.set("n", "<leader>qq", ":q!<CR>", opts)
keymap.set("n", "<leader>qa", ":qa!<CR>", opts)
keymap.set("n", "<leader>ww", ":w<CR>", opts)
keymap.set("n", "<leader>wa", ":wa!<CR>", opts)
keymap.set("n", "gx", ":!xdg-open <c-r><c-a><CR>", opts)

-- Split/window management
keymap.set("n", "<leader>sv", "<C-w>v", opts)
keymap.set("n", "<leader>sh", "<C-w>s", opts)
keymap.set("n", "<leader>se", "<C-w>=", opts)
keymap.set("n", "<leader>sx", ":close<CR>", opts)
keymap.set("n", "<leader>sj", "<C-w>-", opts)
keymap.set("n", "<leader>sk", "<C-w>+", opts)
keymap.set("n", "<leader>sl", "<C-w>>5", opts)
keymap.set("n", "<leader>sw", "<C-w><5", opts)

-- Tab management
keymap.set("n", "<leader>to", ":tabnew<CR>", opts)
keymap.set("n", "<leader>tx", ":tabclose<CR>", opts)
keymap.set("n", "<leader>tn", ":tabn<CR>", opts)
keymap.set("n", "<leader>tp", ":tabp<CR>", opts)

-- Undotree
vim.cmd("packadd nvim.undotree")
keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", opts)

-- Fzf Lua shortcuts
keymap.set("n", "<leader>fl", ":FzfLua<CR>", opts)
keymap.set("n", "<leader>ff", ":FzfLua files<CR>", opts)
keymap.set("n", "<leader>fg", ":FzfLua live_grep<CR>", opts)
keymap.set("n", "<leader>fb", ":FzfLua buffers<CR>", opts)
keymap.set("n", "<leader>fz", ":FzfLua grep_curbuf<CR>", opts)
keymap.set("n", "<leader>fs", ":FzfLua lsp_document_symbols<CR>", opts)

-- LSP actions
keymap.set("n", "<leader>gg", vim.lsp.buf.hover, opts)
keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, opts)
keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
keymap.set("n", "<leader>gs", vim.lsp.buf.signature_help, opts)

keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
keymap.set("n", "<leader>ga", vim.lsp.buf.code_action, opts)

keymap.set({ "n", "v" }, "<leader>gf", function()
  vim.lsp.buf.format({ async = true })
end, opts)

-- Diagnostics
keymap.set("n", "<leader>gl", vim.diagnostic.open_float, opts)
keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev, opts)
keymap.set("n", "<leader>gn", vim.diagnostic.goto_next, opts)

-- Document symbols
keymap.set("n", "<leader>tr", vim.lsp.buf.document_symbol, opts)

-- Completion helper
keymap.set("i", "<C-Space>", function()
  vim.lsp.completion.get()
end, opts)

-----------------
-- Visual mode --
-----------------

keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)
