Reaper = Reaper or {}

local AceGUI = LibStub("AceGUI-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

---@class ConfigWindow
local ConfigWindow = {}
Reaper.ConfigWindow = ConfigWindow
ConfigWindow.__index = ConfigWindow

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
      someOption = {
        type = 'toggle',
        name = 'Some Option',
        desc = 'Toggle option',
        width = "full",
        order = 2,
      },
      anotherOption = {
        type = 'range',
        name = 'Another Option',
        desc = 'Range option',
        min = 1,
        max = 10,
        step = 1,
        order = 3,
        width = "double",
      },
      testButton = {
        type = 'execute',
        name = 'Test Toast',
        order = 4,
        func = function()
          self:ShowTestToast()
        end,
      },
    },
  }

  AceConfig:RegisterOptionsTable("Reaper", options)
  AceConfigDialog:SetDefaultSize("Reaper", 440, 590)
end

local function getConfigWindowInstance()
  if not configWindowInstance then
    configWindowInstance = ConfigWindow:new()
  end
  return configWindowInstance
end

function ConfigWindow:new()
  Reaper:Print("ConfigWindow Created")

  local self = setmetatable({}, ConfigWindow)
  self.manager = ToastManager:new(3)
  self:InitializeConfig()

  return self
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