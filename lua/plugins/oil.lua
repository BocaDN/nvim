vim.pack.add({
    'https://github.com/stevearc/oil.nvim',
})

require("oil").setup({
  default_file_explorer = true,
  -- See :help oil-columns
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
