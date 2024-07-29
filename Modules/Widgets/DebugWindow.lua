Reaper = Reaper or {}

---@class DebugWindow
local DebugWindow = {}
Reaper.DebugWindow = DebugWindow
DebugWindow.__index = DebugWindow

---@class ToastManager
local ToastManager = Reaper.ToastManager

---@param self DebugWindow
---@return window Frame
local function createWindow(self)
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
  return window
end

---@param self DebugWindow
local function addButton(self)
  local testButton = CreateFrame("Button", nil, self.window, "GameMenuButtonTemplate")
  testButton:SetPoint("CENTER", self.window, "CENTER", 0, -10)
  testButton:SetSize(60, 40)
  testButton:SetText("Test")
  testButton:SetNormalFontObject("GameFontNormalLarge")
  testButton:SetHighlightFontObject("GameFontHighlightLarge")

  local manager = ToastManager:new(3)

  testButton:SetScript("OnClick", function()
    manager:addToast("Warrior", "Khadalyonsus", 23, "Stitches", 35)
  end)
end

---@return DebugWindow
function DebugWindow:new()
  Reaper:Print("DebugWindow Created")

  local self = setmetatable({}, DebugWindow)
  self.window = createWindow(self)

  addButton(self)

  return self
end