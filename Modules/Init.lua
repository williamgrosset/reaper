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
  local disabledAlerts = Config:Get("disabledAlerts")
  local minLevel = Config:Get("minLevel")

  if not disabledAlerts and playerLevel >= minLevel then
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
end

function Init:OnPlayerLogin()
  Reaper:Print("Player Logged In")
  registerEvents(self)
end