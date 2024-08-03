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

  -- Disable Deathlog UI alerts to avoid duplication
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

---@param classId number
---@return string
local function getClassName(classId)
  local className, _, _ = GetClassInfo(classId)
  return className
end

---@param deathSourceId number
---@return string
local function getDeathSourceName(deathSourceId)
  -- Check global DNL data
  if id_to_npc[deathSourceId] then
    return id_to_npc[deathSourceId]
  elseif deathSourceId == -2 then
    return "Drowned"
  elseif deathSourceId == -3 then
    return "Fell"
  elseif deathSourceId == -4 then
    return "Fatigued"
  elseif deathSourceId == -5 then
    return "Burned"
  elseif deathSourceId == -6 then
    return "Lava Burned"
  elseif deathSourceId == -7 then
    return "Slimed"
  else
    return "??"
  end
end

---@param classId number
---@param playerName string
---@param playerLevel number
---@param deathSourceId number
local function onDeath(classId, playerName, playerLevel, deathSourceId)
  local className = getClassName(classId)
  local deathSourceName = getDeathSourceName(deathSourceId)

  if verifyAlert(playerLevel) then
    Reaper:Print("Death Alert Allowed")

    local manager = ToastManager:GetInstance()

    manager:addToast(
      className,
      playerName,
      playerLevel,
      deathSourceName
    )
  end
end

local function registerEvents()
  Reaper:Print("Events Registered")

  -- Hook into DNL
  DeathNotificationLib_HookOnNewEntry(function(_player_data, _checksum, num_peer_checks, in_guild)
    onDeath(_player_data.class_id, _player_data.name, _player_data.level, _player_data.source_id)
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

  registerEvents()
end