vim.opt.completeopt = "menu,menuone,noselect,popup"
vim.o.autocomplete = true

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),

  callback = function(args)
    local client_id = args.data.client_id
    if not client_id then
      return
    end

    local client = vim.lsp.get_client_by_id(client_id)

    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client_id, args.buf, {
        autotrigger = true,
      })
    end
  end,
})

local lsp_servers = {
  "pylsp",
  "clangd",
  "lua_ls",
}

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
})

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = lsp_servers,
  automatic_enable = false,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

vim.lsp.enable(lsp_servers)
