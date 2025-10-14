local M = {}

local function read_file(path)
  local file = io.open(path, 'r')
  if not file then
    return ''
  end
  local content = file:read '*all'
  file:close()
  return content
end

M.read_file = read_file

return M
