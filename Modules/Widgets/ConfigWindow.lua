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

-- External alert reference
local deathlogAlertFunc = Deathlog_DeathAlertPlay

-- Constants
local TEST_VALUES = {
  { class = "Paladin", playerName = "Leeroy", playerLevel = 60, creatureName = "Rookery Whelp", location = "Blackrock Spire" },
  { class = "Rogue", playerName = "Edwin", playerLevel = 52, creatureName = "Ravasaur Hunter", location = "Un'Goro Crater" },
  { class = "Warrior", playerName = "Kungen", playerLevel = 36, creatureName = "Bloodscalp Berserker", location = "Stranglethorn Vale" },
  { class = "Druid", playerName = "Cenarius", playerLevel = 28, creatureName = "Felmusk Felsworn", location = "Felwood" },
  { class = "Hunter", playerName = "Legolas", playerLevel = 12, creatureName = "Rabid Thistle Bear", location = "Darkshore" },
  { class = "Mage", playerName = "Merlin", playerLevel = 7, creatureName = "Prowler", location = "Westfall" }
}

-- Singleton
local instance

---@return { class: string, playerName: string, playerLevel: number, creatureName: string, location: string }
local function getRandomTestValue()
  return TEST_VALUES[math.random(1, #TEST_VALUES)]
end

---@param self ConfigWindow
local function setupCloseHook(self)
  -- Hook into the frame's Hide function to detect when window closes
  local frame = AceConfigDialog.OpenFrames["Reaper"]
  if frame and not frame:GetUserData("reaperCloseHooked") then
    local originalHide = frame.Hide
    frame.Hide = function(f)
      self.manager:toggleAnchorVisibility(false)
      originalHide(f)
    end
    frame:SetUserData("reaperCloseHooked", true)
  end
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
        get = function(info) return Config:get("alertsEnabled") end,
        set = function(info, value)
          self:setAlertsEnabled(value)
        end,
      },
      soundEnabled = {
        type = 'toggle',
        name = 'Enable 60 death alert sound',
        desc = 'Enable 60 death alert sound',
        width = "full",
        order = 3,
        get = function(info) return Config:get("soundEnabled") end,
        set = function(info, value) Config:set("soundEnabled", value) end,
      },
      borderEnabled = {
        type = 'toggle',
        name = 'Enable border',
        desc = 'Enable border on death alerts',
        width = "full",
        order = 4,
        get = function(info) return Config:get("borderEnabled") end,
        set = function(info, value) Config:set("borderEnabled", value) end,
      },
      minLevel = {
        type = 'range',
        name = 'Minimum level',
        desc = 'Minimum level to show death alert',
        min = 1,
        max = 60,
        step = 1,
        order = 5,
        width = "double",
        get = function(info) return Config:get("minLevel") end,
        set = function(info, value) Config:set("minLevel", value) end,
      },
      alertDuration = {
        type = 'range',
        name = 'Alert duration',
        desc = 'Duration of death alert',
        min = 1,
        max = 15,
        step = 1,
        order = 6,
        width = "double",
        get = function(info) return Config:get("alertDuration") end,
        set = function(info, value) Config:set("alertDuration", value) end,
      },
      togglePosition = {
        type = 'execute',
        name = 'Toggle Position',
        desc = 'Toggle death alert position',
        order = 7,
        func = function()
          self.manager:toggleAnchorVisibility()
        end,
      },
      resetPosition = {
        type = 'execute',
        name = 'Reset Position',
        desc = 'Reset death alert position',
        order = 8,
        func = function()
          self.manager:resetAnchor()
        end,
      },
      spacer1 = {
        type = 'description',
        name = '',
        order = 9,
        width = "full",
      },
      testAlert = {
        type = 'execute',
        name = 'Test Alert',
        desc = 'Test a death alert',
        order = 10,
        func = function()
          self:generateTestToast()
        end,
      },
      flushQueue = {
        type = 'execute',
        name = 'Flush Queue',
        desc = 'Flush death alerts queue',
        order = 11,
        func = function()
          self.manager:flush()
        end,
      },
      spacer2 = {
        type = 'description',
        name = '',
        order = 12,
        width = "full",
      },
      reset = {
        type = 'execute',
        name = 'Reset to Defaults',
        desc = 'Reset configuration to default values',
        order = 13,
        func = function()
          Config:reset()
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
    local instance = ConfigWindow:getInstance()
    instance:open()
  end
end

local function toggleExternalAlerts()
  local alertsEnabled = Config:get("alertsEnabled")

  if alertsEnabled then
    Deathlog_DeathAlertPlay = function(entry)
      -- Do nothing
    end
  else
    -- Restore original alert
    Deathlog_DeathAlertPlay = deathlogAlertFunc
  end
end

---@return ConfigWindow
function ConfigWindow:new()
  if instance then
    return instance
  end

  local self = setmetatable({}, ConfigWindow)
  self.manager = ToastManager:getInstance()
  loadOptions(self)
  instance = self
  return instance
end

---@return ConfigWindow
function ConfigWindow:initialize()
  instance = ConfigWindow:new()
  initializeCommand()
  toggleExternalAlerts()
  return instance
end

---@return ConfigWindow
function ConfigWindow:getInstance()
  return instance
end

function ConfigWindow:open()
  AceConfigDialog:Open("Reaper")
  setupCloseHook(self)
end

function ConfigWindow:close()
  AceConfigDialog:Close("Reaper")
  -- Hide the anchor when config window is closed
  self.manager:toggleAnchorVisibility(false)
end

---@param value boolean
function ConfigWindow:setAlertsEnabled(value)
  Config:set("alertsEnabled", value)
  toggleExternalAlerts()
end

function ConfigWindow:generateTestToast()
  local testValue = getRandomTestValue()
  self.manager:addToast(
    testValue.playerName,
    testValue.playerLevel,
    testValue.creatureName,
    testValue.location
  )
end