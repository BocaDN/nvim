-- =========================
-- BIDIRECTIONAL JUPYTEXT SYSTEM
-- =========================

local uv = vim.uv or vim.loop

-- persistent registry
local state_file = vim.fn.stdpath("state") .. "/jupy_sync_registry.json"

-- sync registry
local registry = {}

-- active sync locks
local syncing = {}

-- debounce timers
local timers = {}

-- -------------------------
-- helpers
-- -------------------------

local function norm(path)
  return vim.fn.fnamemodify(path, ":p")
end

local function current_file()
  return norm(vim.fn.expand("%:p"))
end

local function has_jupytext()
  return vim.fn.executable("jupytext") == 1
end

local function jupytext_path()
  local p = vim.fn.exepath("jupytext")
  if p == "" then
    return nil
  end
  return p
end

local function is_registered(file)
  return registry[norm(file)] == true
end

-- -------------------------
-- persistence
-- -------------------------

local function save_registry()
  local f = io.open(state_file, "w")

  if not f then
    return
  end

  f:write(vim.fn.json_encode(registry))
  f:close()
end

local function load_registry()
  local f = io.open(state_file, "r")

  if not f then
    return
  end

  local content = f:read("*a")
  f:close()

  local ok, decoded = pcall(vim.fn.json_decode, content)

  if ok and type(decoded) == "table" then
    registry = decoded
  end
end

load_registry()

-- -------------------------
-- registry commands
-- -------------------------

vim.api.nvim_create_user_command("JupySyncAdd", function(opts)
  local file = norm(opts.args ~= "" and opts.args or current_file())

  registry[file] = true
  save_registry()

  vim.notify("Registered:\n" .. file)
end, {
  nargs = "?",
  complete = "file",
})

vim.api.nvim_create_user_command("JupySyncRemove", function(opts)
  local file = norm(opts.args ~= "" and opts.args or current_file())

  registry[file] = nil
  save_registry()

  vim.notify("Removed:\n" .. file)
end, {
  nargs = "?",
  complete = "file",
})

vim.api.nvim_create_user_command("JupySyncList", function()
  print(vim.inspect(registry))
end, {})

-- -------------------------
-- pairing
-- -------------------------

vim.api.nvim_create_user_command("JupyPair", function(opts)
  if not has_jupytext() then
    vim.notify("jupytext not found", vim.log.levels.ERROR)
    return
  end

  local file = norm(opts.args ~= "" and opts.args or current_file())

  local result = vim.fn.system({
    jupytext_path() or "jupytext",
    "--set-formats",
    "ipynb,py:percent",
    file,
  })

  if vim.v.shell_error == 0 then
    registry[file] = true
    save_registry()

    vim.notify("Paired:\n" .. file)
  else
    vim.notify(result, vim.log.levels.ERROR)
  end
end, {
  nargs = "?",
  complete = "file",
})

-- -------------------------
-- actual sync
-- -------------------------

local function sync_file(file)
  if syncing[file] then
    return
  end

  syncing[file] = true

  local jupy = jupytext_path() or "jupytext"

  vim.fn.jobstart({ jupy, "--sync", file }, {
    detach = true,

    on_exit = function(_, exit_code, _)
      syncing[file] = nil

      if exit_code ~= 0 then
        vim.schedule(function()
          vim.notify("jupytext --sync failed (exit code: " .. tostring(exit_code) .. ")", vim.log.levels.ERROR)
        end)
      end

      vim.schedule(function()
        -- only reload clean buffers
        if vim.fn.bufloaded(file) == 1 then
          local bufnr = vim.fn.bufnr(file)

          if vim.bo[bufnr].modified == false then
            vim.cmd("silent checktime " .. bufnr)
          end
        end
      end)
    end,
  })
end

-- -------------------------
-- debounce wrapper
-- -------------------------

local function debounce_sync(file)
  if timers[file] then
    pcall(function()
      timers[file]:stop()
      timers[file]:close()
    end)
    timers[file] = nil
  end

  timers[file] = uv.new_timer()

  timers[file]:start(500, 0, function()
    vim.schedule(function()
      sync_file(file)
    end)
  end)
end

-- -------------------------
-- manual sync
-- -------------------------

vim.api.nvim_create_user_command("JupySync", function(opts)
  local file = norm(opts.args ~= "" and opts.args or current_file())

  if not is_registered(file) then
    vim.notify("Not registered", vim.log.levels.WARN)
    return
  end

  sync_file(file)
end, {
  nargs = "?",
  complete = "file",
})

-- -------------------------
-- autosync
-- -------------------------

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.py", "*.ipynb" },

  callback = function()
    if not has_jupytext() then
      return
    end

    local file = current_file()

    if not is_registered(file) then
      return
    end

    debounce_sync(file)
  end,
})

-- -------------------------
-- editor safety
-- -------------------------

vim.opt.autoread = true
