Reaper = Reaper or {}

---@class Config
local Config = {}
Reaper.Config = Config
Config.__index = Config

-- Constants
local DEFAULT_VALUES = {
  alertsEnabled = true,
  soundEnabled = true,
  minLevel = 1,
  alertDuration = 10
}

function Config:initialize()
  if not ReaperDB then
    ReaperDB = {}
  end
  if not ReaperDB.config then
    ReaperDB.config = {}
  end

  for k, v in pairs(DEFAULT_VALUES) do
    if ReaperDB.config[k] == nil then
      ReaperDB.config[k] = v
    end
  end

  Reaper:print("Run |cFF765BFF/reaper|r to customize your death alerts")
end

---@param key string
---@return any
function Config:get(key)
  return ReaperDB.config[key]
end

---@param key string
---@param value any
function Config:set(key, value)
  ReaperDB.config[key] = value
end

function Config:reset()
  for k in pairs(ReaperDB.config) do
    ReaperDB.config[k] = nil
  end

  for k, v in pairs(DEFAULT_VALUES) do
    ReaperDB.config[k] = v
  end
end
