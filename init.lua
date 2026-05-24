-- Set colorscheme
vim.pack.add({
  'https://github.com/neanias/everforest-nvim',
})
require("everforest").load()

require("vim._core.ui2").enable({})

require("pack")
require("lsp")

require("plugins.mason")
require("plugins.oil")
require("plugins.fzf")
require("plugins.commentary-vim")

-- require("plugins.colorschemes.everforest") -- does not work

require("core.keymaps")
require("core.functions")
require("core.options")
require("core.autocmds")
require("core.disabled")





