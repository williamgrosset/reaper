Reaper = Reaper or {}

---@class Config
local Config = {}
Reaper.Config = Config
Config.__index = Config

local defaultConfig = {
  alertsEnabled = true,
  soundEnabled = true,
  minLevel = 1,
  alertDuration = 8
}

function Config:Initialize()
  if not ReaperDB then
    ReaperDB = {}
  end
  if not ReaperDB.config then
    ReaperDB.config = {}
  end

  for k, v in pairs(defaultConfig) do
    if ReaperDB.config[k] == nil then
      ReaperDB.config[k] = v
    end
  end
end

---@param key string
---@return any
function Config:Get(key)
  return ReaperDB.config[key]
end

---@param key string
---@param value any
function Config:Set(key, value)
  ReaperDB.config[key] = value
end

function Config:Reset()
  for k in pairs(ReaperDB.config) do
    ReaperDB.config[k] = nil
  end

  for k, v in pairs(defaultConfig) do
    ReaperDB.config[k] = v
  end

  Reaper:Print("Configuration reset to defaults")
end
