vim.pack.add({
    'https://github.com/ibhagwan/fzf-lua',
})

require("fzf-lua").setup {
  -- MISC GLOBAL SETUP OPTIONS, SEE BELOW
  -- fzf_bin = ...,
  -- each of these options can also be passed as function that return options table
  -- e.g. winopts = function() return { ... } end
  -- winopts = { ...  },     -- UI Options
  -- keymap = {  },      -- Neovim keymaps / fzf binds
  -- actions = { ...  },     -- Fzf "accept" binds
  -- fzf_opts = { ...  },    -- Fzf CLI flags
  -- fzf_colors = { ...  },  -- Fzf `--color` specification
  -- hls = { ...  },         -- Highlights
  -- previewers = { ...  },  -- Previewers options
  -- SPECIFIC COMMAND/PICKER OPTIONS, SEE BELOW
  -- files = { ... },
}
