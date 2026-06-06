-- =========================
-- Completion settings
-- =========================
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- =========================
-- LSP completion (Neovim 0.11+ / 0.12+)
-- =========================
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),

--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client and client:supports_method("textDocument/completion") then
--       vim.lsp.completion.enable(true, client.id, args.buf)
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),

  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
      })

      -- IMPORTANT: required for fallback completion system
      vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
  end,
})
-- =========================
-- LSP servers
-- =========================
local lsp_servers = {
  "pyright",   -- Python type checking / IntelliSense
  "ruff",      -- linting + formatting
  "clangd",
  "lua_ls",
}

-- =========================
-- Plugins
-- =========================
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

-- =========================
-- Ruff LSP
-- =========================
vim.lsp.config("ruff", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".git",
  },
})

-- =========================
-- Pyright LSP
-- =========================
vim.lsp.config("pyright", {
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- =========================
-- Lua LSP
-- =========================
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})

-- =========================
-- Enable servers
-- =========================
vim.lsp.enable(lsp_servers)
