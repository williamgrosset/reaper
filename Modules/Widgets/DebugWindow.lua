---@class DebugWindow
local DebugWindow = ModuleLoader:UseModule("DebugWindow")
local _DebugWindow = DebugWindow.private

local Popup = ModuleLoader:UseModule("Popup")

function DebugWindow:Create()
  local frame = CreateFrame("Frame", "DebugFrame", UIParent, "BasicFrameTemplateWithInset")
  frame:SetSize(100, 100)
  frame:SetPoint("CENTER")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame.title = frame:CreateFontString(nil, "OVERLAY")
  frame.title:SetFontObject("GameFontHighlight")
  frame.title:SetPoint("CENTER", frame.TitleBg, "CENTER", 0, 0)
  frame.title:SetText("Debug")

  local testButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
  testButton:SetPoint("CENTER", frame, "CENTER", 0, -10)
  testButton:SetSize(60, 40) -- Width, Height
  testButton:SetText("Test")
  testButton:SetNormalFontObject("GameFontNormalLarge")
  testButton:SetHighlightFontObject("GameFontHighlightLarge")

  testButton:SetScript("OnClick", function()
    Popup:Create()
  end)
end