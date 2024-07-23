---@class ModuleLoader
ModuleLoader = {}

---@type table<string, Module>
local modules = {}

---@return Module @Module reference
local function _CreateModule()
  ---@class Module
  local module = {}
  module.private = {}
  return module
end

---@param name string @Module name
---@return Module @Module reference
function ModuleLoader:UseModule(name)
  if not modules[name] then
    modules[name] = _CreateModule()
    return modules[name]
  else
    return modules[name]
  end
end