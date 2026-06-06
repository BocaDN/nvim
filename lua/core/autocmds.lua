vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI" }, {
  callback = function()
    local ft = vim.bo.filetype
    if vim.tbl_contains({ "html", "javascript", "typescript", "css", "scss" }, ft) then
      vim.cmd("silent! update")
    end
  end,
})

