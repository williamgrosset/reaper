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

---@param sourceId number
---@return string
local function getSourceName(sourceId)
  -- Check DNL data
  if id_to_npc[sourceId] then
    return id_to_npc[sourceId]
  elseif sourceId == -2 then
    return "Drowned"
  elseif sourceId == -3 then
    return "Fell"
  elseif sourceId == -4 then
    return "Fatigued"
  elseif sourceId == -5 then
    return "Burned"
  elseif sourceId == -6 then
    return "Lava Burned"
  elseif sourceId == -7 then
    return "Slimed"
  else
    return "??"
  end
end

---@param self Init
local function registerEvents(self)
  Reaper:Print("Events Registered")

  local manager = ToastManager:GetInstance()

  DeathNotificationLib_HookOnNewEntry(function(_player_data, _checksum, num_peer_checks, in_guild)
    Reaper:Print("Death Occurred")
    
    local classId = _player_data.class_id
    local playerName = _player_data.name
    local playerLevel = _player_data.level
    local sourceId = _player_data.source_id
    local className = getClassName(classId)
    local sourceName = getSourceName(sourceId)

    if verifyAlert(playerLevel) then
      Reaper:Print("Death Alert Allowed")

      manager:addToast(
        className,
        playerName,
        playerLevel,
        sourceName,
        99
      )
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