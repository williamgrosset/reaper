Reaper = Reaper or {}

---@class Init
local Init = {}
Reaper.Init = Init
Init.__index = Init

---@class Config
local Config = Reaper.Config

---@param self Init
local function registerEvents(self)
  Reaper:Print("Events Registered")
  DeathNotificationLib_HookOnNewEntry(function(_player_data, _checksum, num_peer_checks, in_guild)
    Reaper:Print("Death Occurred")
  end)
end

function Init:OnAddonLoaded()
  Reaper:Print("Addon Loaded")
  Config:Initialize()
end

function Init:OnPlayerLogin()
  Reaper:Print("Player Logged In")
  registerEvents(self)
end