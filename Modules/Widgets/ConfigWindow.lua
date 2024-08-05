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

-- Constants
local TEST_VALUES = {
  { class = "Paladin", playerName = "Leeroy", playerLevel = 60, creatureName = "Rookery Whelp" },
  { class = "Rogue", playerName = "Edwin", playerLevel = 52, creatureName = "Ravasaur Hunter" },
  { class = "Warrior", playerName = "Kungen", playerLevel = 36, creatureName = "Bloodscalp Berserker" },
  { class = "Druid", playerName = "Cenarius", playerLevel = 28, creatureName = "Felmusk Felsworn" },
  { class = "Hunter", playerName = "Legolas", playerLevel = 12, creatureName = "Rabid Thistle Bear" },
  { class = "Mage", playerName = "Merlin", playerLevel = 7, creatureName = "Prowler" }
}

-- Singleton
local instance

---@return { class: string, playerName: string, playerLevel: number, creatureName: string }
local function getRandomTestValue()
  return TEST_VALUES[math.random(1, #TEST_VALUES)]
end

---@param self ConfigWindow
local function loadOptions(self)
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
      alertsEnabled = {
        type = 'toggle',
        name = 'Enable alerts',
        desc = 'Enable all death alerts',
        width = "full",
        order = 2,
        get = function(info) return Config:Get("alertsEnabled") end,
        set = function(info, value) Config:Set("alertsEnabled", value) end,
      },
      soundEnabled = {
        type = 'toggle',
        name = 'Enable 60 death alert sound',
        desc = 'Enable 60 death alert sound',
        width = "full",
        order = 3,
        get = function(info) return Config:Get("soundEnabled") end,
        set = function(info, value) Config:Set("soundEnabled", value) end,
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
        desc = 'Duration of death alert',
        min = 1,
        max = 15,
        step = 1,
        order = 5,
        width = "double",
        get = function(info) return Config:Get("alertDuration") end,
        set = function(info, value) Config:Set("alertDuration", value) end,
      },
      togglePosition = {
        type = 'execute',
        name = 'Toggle Position',
        desc = 'Toggle death alert position',
        order = 6,
        func = function()
          self.manager:ToggleAnchorVisibility()
        end,
      },
      resetPosition = {
        type = 'execute',
        name = 'Reset Position',
        desc = 'Reset death alert position',
        order = 7,
        func = function()
          self.manager:ResetAnchor()
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
          self:GenerateTestToast()
        end,
      },
      flushQueue = {
        type = 'execute',
        name = 'Flush Queue',
        desc = 'Flush death alerts queue',
        order = 10,
        func = function()
          self.manager:flush()
        end,
      },
      spacer2 = {
        type = 'description',
        name = '',
        order = 11,
        width = "full",
      },
      reset = {
        type = 'execute',
        name = 'Reset to Defaults',
        desc = 'Reset configuration to default values',
        order = 12,
        func = function()
          Config:Reset()
          AceConfigDialog:SelectGroup("Reaper")
        end,
      },
    },
  }

  AceConfig:RegisterOptionsTable("Reaper", options)
  AceConfigDialog:SetDefaultSize("Reaper", 440, 500) 
end

local function initializeCommand()
  SLASH_REAPER1 = "/reaper"
  SlashCmdList["REAPER"] = function()
    local instance = ConfigWindow:GetInstance()
    instance:Open()
  end
end

---@return ConfigWindow
function ConfigWindow:New()
  if instance then
    return instance
  end

  Reaper:Print("ConfigWindow Created")

  local self = setmetatable({}, ConfigWindow)
  self.manager = ToastManager:GetInstance() or ToastManager:new(3)
  loadOptions(self)
  instance = self
  return instance
end

---@return ConfigWindow
function ConfigWindow:Initialize()
  instance = ConfigWindow:New()
  initializeCommand()
  return instance
end

---@return ConfigWindow
function ConfigWindow:GetInstance()
  return instance
end

function ConfigWindow:Open()
  AceConfigDialog:Open("Reaper")
end

function ConfigWindow:GenerateTestToast()
  local testValue = getRandomTestValue()
  self.manager:addToast(
    testValue.class,
    testValue.playerName,
    testValue.playerLevel,
    testValue.creatureName
  )
end