vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" },
})

local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  vim.schedule(function()
    vim.notify("nvim-lspconfig not available; Python LSP will not start.", vim.log.levels.WARN)
  end)
  return
end

local node_cmd = vim.fn.executable("node") == 1 and "node" or nil
local pyright_js = vim.fn.stdpath("data") .. "/mason/packages/pyright/node_modules/pyright/dist/pyright-langserver.js"
local cmd
if vim.fn.executable("pyright-langserver") == 1 then
  cmd = { "pyright-langserver", "--stdio" }
elseif node_cmd and vim.fn.filereadable(pyright_js) == 1 then
  cmd = { node_cmd, pyright_js, "--stdio" }
else
  vim.schedule(function()
    vim.notify("pyright not found. Install it with Mason or npm and restart Neovim.", vim.log.levels.WARN)
  end)
  return
end

local venv = vim.env.VIRTUAL_ENV or ""
local venv_path = ""
local venv_name = ""
if venv ~= "" then
  venv_path = vim.fn.fnamemodify(venv, ":h")
  venv_name = vim.fn.fnamemodify(venv, ":t")
end

local pyright_settings = {
  python = {
    analysis = {
      autoSearchPaths = true,
      diagnosticMode = "workspace",
      useLibraryCodeForTypes = true,
    },
  },
}
if venv_path ~= "" then
  pyright_settings.python.analysis.venvPath = venv_path
end
if venv_name ~= "" then
  pyright_settings.python.analysis.venv = venv_name
end

lspconfig.pyright.setup({
  cmd = cmd,
  settings = pyright_settings,
})
