---@class Popup
local Popup = ModuleLoader:UseModule("Popup")
local _Popup = Popup.private

function Popup:Create()
  Reaper:Print("creating popup")

  -- Create the main frame
  local frame = CreateFrame("Frame", "PopupFrame", UIParent, "BasicFrameTemplateWithInset")
  frame:SetSize(300, 200)
  frame:SetPoint("CENTER")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame:SetScript("OnHide", function() frame:Hide() end)

  _Popup:AddLabel(frame)
end

---@param frame Frame
function _Popup:AddLabel(frame)
  frame.label = frame:CreateFontString(nil, "OVERLAY")
  frame.label:SetFontObject("GameFontNormal")
  frame.label:SetPoint("CENTER", frame, "CENTER", 0, 20)
  frame.label:SetText("This is a simple popup.")
end