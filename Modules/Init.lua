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

local function disableExternalUIAlerts()
  local alertsEnabled = Config:Get("alertsEnabled")
  local deathLogSettings = deathlog_settings

  -- Disable Deathlog addon UI alerts to avoid duplication
  if alertsEnabled and deathLogSettings and deathLogSettings["DeathAlert"] then
    Reaper:Print("Disabling external alerts")
    deathLogSettings["DeathAlert"]["enable"] = false
  end
end

---@param playerLevel number
---@return boolean
local function verifyAlert(playerLevel)
  local alertsEnabled = Config:Get("alertsEnabled")
  local minLevel = Config:Get("minLevel")

  if alertsEnabled and playerLevel >= minLevel then
    return true
  end

  return false
end

---@param self Init
local function registerEvents(self)
  Reaper:Print("Events Registered")

  DeathNotificationLib_HookOnNewEntry(function(_player_data, _checksum, num_peer_checks, in_guild)
    Reaper:Print("Death Occurred")
    
    local playerLevel = _player_data.level

    if verifyAlert(playerLevel) then
      Reaper:Print("Death Alert Allowed")
    end
  end)
end

function Init:OnAddonLoaded()
  Reaper:Print("Addon Loaded")
  Config:Initialize()
  ConfigWindow:Initialize()
  ToastManager:Initialize(3)
  disableExternalUIAlerts()
end

function Init:OnPlayerLogin()
  Reaper:Print("Player Logged In")
  registerEvents(self)
end