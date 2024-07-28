Reaper = Reaper or {}

---@class DebugWindow
local DebugWindow = {}
Reaper.DebugWindow = DebugWindow
DebugWindow.__index = DebugWindow

---@class DeathToast
local DeathToast = Reaper.DeathToast

---@param self DebugWindow
local function createFrame(self)
  local window = CreateFrame("Frame", "DebugFrame", UIParent, "BasicFrameTemplateWithInset")
  window:SetSize(100, 100)
  window:SetPoint("CENTER")
  window:SetMovable(true)
  window:EnableMouse(true)
  window:RegisterForDrag("LeftButton")
  window:SetScript("OnDragStart", window.StartMoving)
  window:SetScript("OnDragStop", window.StopMovingOrSizing)
  window.title = window:CreateFontString(nil, "OVERLAY")
  window.title:SetFontObject("GameFontHighlight")
  window.title:SetPoint("CENTER", window.TitleBg, "CENTER", 0, 0)
  window.title:SetText("Debug")
  self.window = window
end

---@param self DebugWindow
local function addButton(self)
  local testButton = CreateFrame("Button", nil, self.window, "GameMenuButtonTemplate")
  testButton:SetPoint("CENTER", self.window, "CENTER", 0, -10)
  testButton:SetSize(60, 40)
  testButton:SetText("Test")
  testButton:SetNormalFontObject("GameFontNormalLarge")
  testButton:SetHighlightFontObject("GameFontHighlightLarge")
  testButton:SetScript("OnClick", function()
    -- Death mock:
    -- Fable <Drow> level 20 rogue was slain by Defias Smuggler in Elwynn Forest
    local toast = DeathToast:new()
    toast:Create('Fable', '<Drow>', 4, 20, 95, 1429)
  end)
end

function DebugWindow:new()
  local self = setmetatable({}, DebugWindow)
  self.window = nil
  return self
end

function DebugWindow:Create()
  Reaper:Print("DebugWindow Created")

  createFrame(self)
  addButton(self)
end