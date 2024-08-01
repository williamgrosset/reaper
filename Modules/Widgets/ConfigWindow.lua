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

-- Singleton
local instance

local testValues = {
  { class = "Paladin", playerName = "Leeroy", playerLevel = 60, creatureName = "Rookery Whelp", creatureLevel = 57 },
  { class = "Rogue", playerName = "Edwin", playerLevel = 52, creatureName = "Ravasaur Hunter", creatureLevel = 50 },
  { class = "Warrior", playerName = "Kungen", playerLevel = 36, creatureName = "Bloodscalp Berserker", creatureLevel = 37 },
  { class = "Druid", playerName = "Cenarius", playerLevel = 28, creatureName = "Felmusk Felsworn", creatureLevel = 26 },
  { class = "Hunter", playerName = "Legolas", playerLevel = 12, creatureName = "Rabid Thistle Bear", creatureLevel = 13 },
}

local function getRandomTestValue()
  local index = math.random(1, #testValues)
  return testValues[index]
end

local function initializeCommand()
  SLASH_REAPER1 = "/reaper"
  SlashCmdList["REAPER"] = function()
    local instance = ConfigWindow:new()
    instance:Open()
  end
end

---@return ConfigWindow
function ConfigWindow:new()
  if instance then
    return instance
  end

  Reaper:Print("ConfigWindow Created")

  local self = setmetatable({}, ConfigWindow)
  self:InitializeConfig()
  instance = self
  return instance
end

---@return ConfigWindow
function ConfigWindow:GetInstance()
  return instance
end

---@return ConfigWindow
function ConfigWindow:Initialize()
  instance = ConfigWindow:new()
  initializeCommand()
  return instance
end

function ConfigWindow:Open()
  AceConfigDialog:Open("Reaper")
end

function ConfigWindow:ShowTestToast()
  local manager = ToastManager:GetInstance()
  local testValue = getRandomTestValue()
  manager:addToast(
    testValue.class,
    testValue.playerName,
    testValue.playerLevel,
    testValue.creatureName,
    testValue.creatureLevel
  )
end

function ConfigWindow:FlushQueue()
  local manager = ToastManager:GetInstance()
  manager:flush()
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
      alertsEnabled = {
        type = 'toggle',
        name = 'Enable alerts',
        desc = 'Enable all death alerts',
        width = "full",
        order = 2,
        get = function(info) return Config:Get("alertsEnabled") end,
        set = function(info, value) Config:Set("alertsEnabled", value) end,
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
      alertDuration = {
        type = 'range',
        name = 'Alert duration',
        desc = 'Duration of death alert',
        min = 1,
        max = 10,
        step = 1,
        order = 4,
        width = "double",
        get = function(info) return Config:Get("alertDuration") end,
        set = function(info, value) Config:Set("alertDuration", value) end,
      },
      togglePosition = {
        type = 'execute',
        name = 'Toggle Position',
        desc = 'Toggle death alert position',
        order = 5,
        func = function()
          self:ShowTestToast()
        end,
      },
      resetPosition = {
        type = 'execute',
        name = 'Reset Position',
        desc = 'Reset death alert position',
        order = 6,
        func = function()
          self:ShowTestToast()
        end,
      },
      spacer1 = {
        type = 'description',
        name = '',
        order = 7,
        width = "full",
      },
      testAlert = {
        type = 'execute',
        name = 'Test Alert',
        desc = 'Test a death alert',
        order = 8,
        func = function()
          self:ShowTestToast()
        end,
      },
      flushQueue = {
        type = 'execute',
        name = 'Flush Queue',
        desc = 'Flush death alerts queue',
        order = 9,
        func = function()
          self:FlushQueue()
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
          Config:Reset()
          AceConfigDialog:SelectGroup("Reaper")
        end,
      },
    },
  }

  AceConfig:RegisterOptionsTable("Reaper", options)
  AceConfigDialog:SetDefaultSize("Reaper", 440, 500) 
end