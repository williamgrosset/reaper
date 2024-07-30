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
        name = 'Disable alerts',
        desc = 'Disable all death alerts',
        width = "full",
        order = 2,
        get = function(info) return Config:Get("disabledAlerts") end,
        set = function(info, value) Config:Set("disabledAlerts", value) end,
      },
      minLevel = {
        type = 'range',
        name = 'Minimum level',
        desc = 'Minimum level to show death alert',
        min = 1,
        max = 60,
        step = 1,
        order = 3,
        width = "double",
        get = function(info) return Config:Get("minLevel") end,
        set = function(info, value) Config:Set("minLevel", value) end,
      },
      spacer1 = {
        type = 'description',
        name = '',
        order = 4,
        width = "full",
      },
      testButton = {
        type = 'execute',
        name = 'Test Alert',
        desc = 'Test a death alert',
        order = 5,
        func = function()
          self:ShowTestToast()
        end,
      },
      spacer2 = {
        type = 'description',
        name = '',
        order = 6,
        width = "full",
      },
      resetButton = {
        type = 'execute',
        name = 'Reset to Defaults',
        desc = 'Reset configuration to default values',
        order = 7,
        func = function()
          Reaper.Config:Reset()
          AceConfigDialog:SelectGroup("Reaper")
        end,
      },
    },
  }

  AceConfig:RegisterOptionsTable("Reaper", options)
  AceConfigDialog:SetDefaultSize("Reaper", 440, 590)
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