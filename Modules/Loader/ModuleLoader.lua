---@class ModuleLoader
ModuleLoader = {}

---@type table<string, Module>
local modules = {}

---@return Module @Module reference
local function _CreateBlankModule()
  ---@class Module
  local module = {}
  module.private = {}
  return module
end

---@param name string @Module name
---@return Module @Module reference
function ModuleLoader:CreateModule(name)
  if not modules[name] then
    modules[name] = _CreateBlankModule()
    return modules[name]
  else
    return modules[name]
  end
end

---@param name string @Module name
---@return Module @Module reference
function ModuleLoader:ImportModule(name)
  if not modules[name] then
    error("Importing a module that has not been created")
  else
    return modules[name]
  end
end