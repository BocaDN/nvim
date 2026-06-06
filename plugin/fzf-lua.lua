vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons", name = "mini.icons" },
	{ src = "https://github.com/ibhagwan/fzf-lua", name = "fzf-lua" },
})
require("fzf-lua").setup()
vim.keymap.set("n", "<leader>fr", require("fzf-lua").resume, { desc = "Resume fzf-lua" })
