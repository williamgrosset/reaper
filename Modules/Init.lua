Reaper = Reaper or {}

---@class Init
local Init = {}
Reaper.Init = Init
Init.__index = Init

---@class Config
local Config = Reaper.Config

---@class ConfigWindow
local ConfigWindow = Reaper.ConfigWindow

---@class ToastManager
local ToastManager = Reaper.ToastManager

---@param playerLevel number
---@return boolean
local function verifyAlert(playerLevel)
  local alertsEnabled = Config:get("alertsEnabled")
  local minLevel = Config:get("minLevel")

  if alertsEnabled and playerLevel >= minLevel then
    return true
  end

  return false
end

---@param playerName string
---@param playerLevel number
---@param deathSourceName string
local function onDeath(playerName, playerLevel, deathSourceName)
  if verifyAlert(playerLevel) then
    local manager = ToastManager:getInstance()
    manager:addToast(
      playerName,
      playerLevel,
      deathSourceName
    )
  end
end

local function registerEvents()
  -- Hook into our simplified death notification handler
  local DeathNotificationHandler = Reaper.DeathNotificationHandler
  DeathNotificationHandler.HookOnNewEntry(function(death_data)
    -- Use source_name directly from the Blizzard death message
    onDeath(death_data.name, death_data.level, death_data.source_name)
  end)
end

function Init:onAddonLoaded()
  Config:initialize()
  ToastManager:initialize(3)
  ConfigWindow:initialize()
end

function Init:onPlayerLogin()
  local DeathNotificationHandler = Reaper.DeathNotificationHandler
  DeathNotificationHandler:initialize()
  registerEvents()
end