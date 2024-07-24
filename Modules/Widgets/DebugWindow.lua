---@class DebugWindow
local DebugWindow = ModuleLoader:CreateModule("DebugWindow")
local _DebugWindow = DebugWindow.private

local DeathToast = ModuleLoader:ImportModule("DeathToast")

function DebugWindow:Create()
  Reaper:Print("DebugWindow Created")

  local frame = _DebugWindow:CreateFrame()
  _DebugWindow:AddButton(frame)
end

function _DebugWindow:CreateFrame()
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
  return frame
end

---@param frame Frame
function _DebugWindow:AddButton(frame)
  local testButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
  testButton:SetPoint("CENTER", frame, "CENTER", 0, -10)
  testButton:SetSize(60, 40)
  testButton:SetText("Test")
  testButton:SetNormalFontObject("GameFontNormalLarge")
  testButton:SetHighlightFontObject("GameFontHighlightLarge")
  testButton:SetScript("OnClick", function()
    -- Death mock:
    -- Fable <Drow> level 20 rogue was slain by Defias Smuggler in Elwynn Forest
    DeathToast:Create('Fable', '<Drow>', 4, 20, 95, 1429)
  end)
end