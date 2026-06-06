vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" },
})

-- Resolve pyright command
local node_cmd = vim.fn.executable("node") == 1 and "node" or nil
local pyright_js = vim.fn.stdpath("data")
  .. "/mason/packages/pyright/node_modules/pyright/dist/pyright-langserver.js"

local cmd
if vim.fn.executable("pyright-langserver") == 1 then
  cmd = { "pyright-langserver", "--stdio" }
elseif node_cmd and vim.fn.filereadable(pyright_js) == 1 then
  cmd = { node_cmd, pyright_js, "--stdio" }
else
  vim.schedule(function()
    vim.notify("pyright not found. Install it via Mason or npm.", vim.log.levels.WARN)
  end)
  return
end

-- Virtualenv detection
local venv = vim.env.VIRTUAL_ENV or ""
local venv_path = ""
local venv_name = ""

if venv ~= "" then
  venv_path = vim.fn.fnamemodify(venv, ":h")
  venv_name = vim.fn.fnamemodify(venv, ":t")
end

-- Pyright settings
local settings = {
  python = {
    analysis = {
      autoSearchPaths = true,
      diagnosticMode = "workspace",
      useLibraryCodeForTypes = true,
    },
  },
}

if venv_path ~= "" then
  settings.python.analysis.venvPath = venv_path
end

if venv_name ~= "" then
  settings.python.analysis.venv = venv_name
end

-- ✅ NEW API (Neovim 0.11+)
vim.lsp.config("pyright", {
  cmd = cmd,
  settings = settings,
})

vim.lsp.enable("pyright")
