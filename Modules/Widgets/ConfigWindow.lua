Reaper = Reaper or {}

local AceGUI = LibStub("AceGUI-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

---@class ConfigWindow
local ConfigWindow = {}
Reaper.ConfigWindow = ConfigWindow
ConfigWindow.__index = ConfigWindow

---@class Config
local Config = Reaper.Config

---@class ToastManager
local ToastManager = Reaper.ToastManager

function ConfigWindow:Open()
  AceConfigDialog:Open("Reaper")
end

function ConfigWindow:ShowTestToast()
  if self.manager then
    self.manager:addToast("Rogue", "Fable", 52, "Ravasaur Hunter", 50)
  else
    Reaper:Print("ToastManager not initialized.")
  end
end

function ConfigWindow:InitializeConfig()
  local options = {
    name = "Reaper",
    handler = Reaper,
    type = 'group',
    args = {
      header = {
        type = 'header',
        name = 'General Settings',
        order = 1,
      },
      disabledAlerts = {
        type = 'toggle',
        name = 'Disable Reaper alerts',
        desc = 'Disable Reaper death alerts',
        width = "full",
        order = 2,
        get = function(info) return Config:Get("disabledAlerts") end,
        set = function(info, value) Config:Set("disabledAlerts", value) end,
      },
      disabledOtherAlerts = {
        type = 'toggle',
        name = 'Disable Blizzard & Deathlog alerts',
        desc = 'Disable Blizzard & Deathlog death alerts',
        width = "full",
        order = 3,
      },
      minLevel = {
        type = 'range',
        name = 'Minimum level',
        desc = 'Minimum level to show death alert',
        min = 1,
        max = 60,
        step = 1,
        order = 4,
        width = "double",
        get = function(info) return Config:Get("minLevel") end,
        set = function(info, value) Config:Set("minLevel", value) end,
      },
      alertDuration = {
        type = 'range',
        name = 'Alert duration',
        desc = 'Duration of alert shown',
        min = 1,
        max = 10,
        step = 1,
        order = 5,
        width = "double",
      },
      togglePosition = {
        type = 'execute',
        name = 'Toggle Position',
        desc = 'Toggle death alert position',
        order = 6,
        func = function()
          self:ShowTestToast()
        end,
      },
      resetPosition = {
        type = 'execute',
        name = 'Reset Position',
        desc = 'Reset death alert position',
        order = 7,
        func = function()
          self:ShowTestToast()
        end,
      },
      spacer1 = {
        type = 'description',
        name = '',
        order = 8,
        width = "full",
      },
      testAlert = {
        type = 'execute',
        name = 'Test Alert',
        desc = 'Test a death alert',
        order = 9,
        func = function()
          self:ShowTestToast()
        end,
      },
      spacer2 = {
        type = 'description',
        name = '',
        order = 10,
        width = "full",
      },
      reset = {
        type = 'execute',
        name = 'Reset to Defaults',
        desc = 'Reset configuration to default values',
        order = 11,
        func = function()
          Reaper.Config:Reset()
          AceConfigDialog:SelectGroup("Reaper")
        end,
      },
    },
  }

  AceConfig:RegisterOptionsTable("Reaper", options)
  AceConfigDialog:SetDefaultSize("Reaper", 440, 500) 
end

---@return ConfigWindow
function ConfigWindow:new()
  Reaper:Print("ConfigWindow Created")

  local self = setmetatable({}, ConfigWindow)
  self.manager = ToastManager:new(3)
  self:InitializeConfig()

  return self
end

local function getConfigWindowInstance()
  if not configWindowInstance then
    configWindowInstance = ConfigWindow:new()
  end
  return configWindowInstance
end


function ConfigWindow:RegisterSlashCommand()
  SLASH_REAPER1 = "/reaper"
  SlashCmdList["REAPER"] = function()
    local instance = getConfigWindowInstance()
    instance:Open()
  end
end

-- Singleton instance
local configWindowInstance

ConfigWindow:RegisterSlashCommand()