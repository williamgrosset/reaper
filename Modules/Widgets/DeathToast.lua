---@class DeathToast
local DeathToast = ModuleLoader:UseModule("DeathToast")
local _DeathToast = DeathToast.private

---@param player_name string
---@param guild_name string
---@param class_id number
---@param player_level number
---@param creature_id number
---@param zone_id number
function DeathToast:Create(player_name, guild_name, class_id, player_level, creature_id, zone_id)
  Reaper:Print("DeathToast Created")

  local frame = _DeathToast:CreateFrame()
  _DeathToast:AddLabel(frame)
end

function _DeathToast:CreateFrame()
  local frame = CreateFrame("Frame", "DeathToastFrame", UIParent, "BasicFrameTemplate")
  frame:SetSize(200, 100)
  frame:SetPoint("CENTER")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame:SetScript("OnHide", function() frame:Hide() end)
  return frame
end

---@param frame Frame
function _DeathToast:AddLabel(frame)
  frame.label = frame:CreateFontString(nil, "OVERLAY")
  frame.label:SetFontObject("GameFontNormal")
  frame.label:SetPoint("CENTER", frame, "CENTER", 0, 0)
  frame.label:SetText("This is a simple toast.")
end