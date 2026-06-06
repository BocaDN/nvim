vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim", name = "oil.nvim" },
})

local ok, oil = pcall(require, "oil")
if not ok then
  return
end

oil.setup({
  use_default_keymaps = true,
  default_file_explorer = true,
  columns = { "icon", "permissions", "size", "mtime" },
  view_options = { show_hidden = true },
})

vim.keymap.set("n", "-", "<CMD>Oil <CR>", { desc = "Open parent directory" })
