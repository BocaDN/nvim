-- Table to store synced files
local jupy_sync_registry = {}

-- helper: normalize path
local function norm(path)
  return vim.fn.fnamemodify(path, ":p")
end

-- check if file is registered
local function is_registered(file)
  file = norm(file)
  return jupy_sync_registry[file] == true
end

-- add file to registry
vim.api.nvim_create_user_command("JupySyncAdd", function(opts)
  local file = norm(opts.args ~= "" and opts.args or vim.fn.expand("%"))

  jupy_sync_registry[file] = true
  print("Added to JupySync: " .. file)
end, {
  nargs = "?",
  complete = "file",
})

-- remove file from registry
vim.api.nvim_create_user_command("JupySyncRemove", function(opts)
  local file = norm(opts.args ~= "" and opts.args or vim.fn.expand("%"))

  jupy_sync_registry[file] = nil
  print("Removed from JupySync: " .. file)
end, {
  nargs = "?",
  complete = "file",
})

-- manual sync command
vim.api.nvim_create_user_command("JupySync", function(opts)
  local file = norm(opts.args ~= "" and opts.args or vim.fn.expand("%"))

  local cmd = { "jupytext", "--sync", file }
  local result = vim.fn.system(cmd)

  if vim.v.shell_error == 0 then
    print("JupySync OK: " .. file)
  else
    print("JupySync FAILED:\n" .. result)
  end
end, {
  nargs = "?",
  complete = "file",
})

-- autosync ONLY for registered files
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    local file = vim.fn.expand("%:p")

    -- run async, avoid touching buffer state
    vim.fn.jobstart({ "jupytext", "--sync", file }, {
      detach = true,
      on_exit = function()
        -- silently reload file if needed
        vim.schedule(function()
          if vim.fn.bufexists(file) == 1 then
            vim.cmd("checktime")
          end
        end)
      end,
    })
  end,
})
