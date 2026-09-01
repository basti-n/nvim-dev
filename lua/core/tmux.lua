local M = {}

local function notify_warn(msg)
  vim.notify(msg, vim.log.levels.WARN)
end

local function in_tmux()
  return vim.env.TMUX ~= nil and vim.env.TMUX ~= ''
end

function M.popup(opts)
  opts = opts or {}

  if not in_tmux() then
    notify_warn 'Not inside tmux'
    return
  end

  local cmd = opts.cmd
  if cmd == nil or cmd == '' then
    notify_warn 'tmux.popup: missing cmd'
    return
  end

  local width = opts.width or '95%'
  local height = opts.height or '95%'
  local title = opts.title

  local argv = {
    'tmux',
    'popup',
    '-E',
    '-w',
    width,
    '-h',
    height,
  }

  if title ~= nil and title ~= '' then
    table.insert(argv, '-T')
    table.insert(argv, title)
  end

  table.insert(argv, cmd)

  vim.system(argv, { detach = true })
end

return M
