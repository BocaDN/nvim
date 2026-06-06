vim.api.nvim_create_user_command("JupySync", function()
  local file = vim.fn.expand("%:p")

  if file == "" then
    print("No file detected")
    return
  end

  local cmd = "jupytext --sync " .. vim.fn.shellescape(file)
  local output = vim.fn.system(cmd)

  if vim.v.shell_error == 0 then
    print("Jupytext sync OK")
  else
    print("Jupytext sync failed:\n" .. output)
  end
end, {})

function Todo_toggle()
  local line = vim.api.nvim_get_current_line()

  if line:match("TODO%s+?") then
    local new = line:gsub("TODO%s+?", "TODO ✗", 1)
    vim.api.nvim_set_current_line(new)
    return
  elseif line:match("TODO%s+✗") then
    local new = line:gsub("TODO%s+✗", "TODO ✓", 1)
    vim.api.nvim_set_current_line(new)
    return
  elseif line:match("TODO%s+✓") then
    local new = line:gsub("TODO%s+✓", "TODO ?", 1)
    vim.api.nvim_set_current_line(new)
    return
  end

  if line:match("TODO") then
    local new = line:gsub("TODO", "TODO ✓", 1)
    vim.api.nvim_set_current_line(new)
    return
  end
end

function Add_todo_above()
  vim.cmd(":call append(line('.')-1,'TODO ✗:') | .-1Commentary")
end

function Add_todo_end()
  local line = vim.fn.getline(".")
  vim.fn.setline(".", " TODO ✗:")
  vim.cmd("Commentary")
  local todo = vim.fn.getline(".")
  vim.fn.setline(".", line .. todo)
end

vim.keymap.set("n", "<leader>td", Add_todo_above)
vim.keymap.set("n", "<leader>tg", Todo_toggle)
vim.keymap.set("n", "<leader>etd", Add_todo_end)
