---Synchronously executes a shell command and returns its output.
---Calls the provided callback with the result if given.
---@param child string
---@param callback fun(result: string?)
---@return string?
local execSync = function(child, callback)
  local handle = io.popen(child or "", "r")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if callback then
      callback(result)
    end
    return result
  else
    return nil
  end
end

return execSync
