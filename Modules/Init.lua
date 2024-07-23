---@class Init
local Init = ModuleLoader:UseModule("Init")
local _Init = Init.private

local Popup = ModuleLoader:UseModule("Popup")

function Init:OnAddonLoaded()
  Reaper:Print("Addon Loaded")
end

function Init:OnPlayerLogin()
  Reaper:Print("Player Logged In")
  _Init:RegisterEvents()
end

function _Init:RegisterEvents()
  Reaper:Print("Events Registered")
  DeathNotificationLib_HookOnNewEntry(function(_player_data, _checksum, num_peer_checks, in_guild)
    Reaper:Print("new death alert")
    Popup:Create()
  end)
end