---@class DeathToast
local DeathToast = ModuleLoader:CreateModule("DeathToast")
local _DeathToast = DeathToast.private

---@param player_name string
---@param guild_name string
---@param class_id number
---@param player_level number
---@param creature_id number
---@param zone_id number
function DeathToast:Create(player_name, guild_name, class_id, player_level, creature_id, zone_id)
  Reaper:Print("DeathToast Created")

  -- Dummy example
  local toast = _DeathToast:CreateToast()
  local classIcon = _DeathToast:AddClassIcon(toast, "Druid")
  _DeathToast:AddPlayerLabel(toast, classIcon, "Rolandmartin", "(51)")
  _DeathToast:AddCreatureLabel(toast, classIcon, "Boar", "(61)")

  toast:Show()
end

function _DeathToast:CreateToast()
  local toast = CreateFrame("Frame", "CustomTooltip", UIParent, "BackdropTemplate")
  toast:Hide()

  toast:EnableMouse(true)
  toast:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" then
      self:Hide()
    end
  end)


  toast:SetSize(272, 64)
  toast:SetPoint("TOP", 0, -100)

  toast:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
  })
  toast:SetBackdropColor(0, 0, 0, 1)
  toast:SetBackdropBorderColor(0.639, 0.208, 0.933, 1) -- Purple (Epic)

  return toast
end

---@param toast Frame
---@param classIcon Frame
---@param text string
---@param level string
function _DeathToast:AddPlayerLabel(toast, classIcon, text, level)
  local container = CreateFrame("Frame", nil, toast)
  
  local mainText = container:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  mainText:SetText(text)

  local levelText = container:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  levelText:SetText(level)
  levelText:SetTextColor(0.639, 0.208, 0.933) -- Purple (Epic)

  local totalWidth = mainText:GetStringWidth() + levelText:GetStringWidth()

  local iconPaddingLeft = 8
  local iconPaddingRight = 8
  local iconWidth = classIcon:GetWidth() + iconPaddingLeft + iconPaddingRight

  container:SetSize(totalWidth, mainText:GetStringHeight())
  
  local toastWidth = toast:GetWidth()
  container:SetPoint("LEFT", classIcon, "RIGHT", (toastWidth - iconWidth - totalWidth) / 2 - iconPaddingRight, 10)
  
  mainText:SetPoint("LEFT", container, "LEFT")
  levelText:SetPoint("LEFT", mainText, "RIGHT", 3, 0)
end

---@param toast Frame
---@param classIcon Frame
---@param text string
---@param level string
function _DeathToast:AddCreatureLabel(toast, classIcon, text, level)
  local container = CreateFrame("Frame", nil, toast)

  local mainText = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  mainText:SetText(text)

  local skullTexture = container:CreateTexture(nil, "ARTWORK")
  skullTexture:SetTexture("Interface\\AddOns\\Reaper\\Icons\\Skull")
  skullTexture:SetSize(16, 16)

  local levelText = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  levelText:SetText(level)
  levelText:SetTextColor(1, 0, 0)

  local totalWidth = skullTexture:GetWidth() + mainText:GetStringWidth() + levelText:GetStringWidth() + 4

  local iconPaddingLeft = 8
  local iconPaddingRight = 8
  local iconWidth = classIcon:GetWidth() + iconPaddingLeft + iconPaddingRight

  container:SetSize(totalWidth, mainText:GetStringHeight())

  local toastWidth = toast:GetWidth()
  container:SetPoint("LEFT", classIcon, "RIGHT", (toastWidth - iconWidth - totalWidth) / 2 - iconPaddingRight, -10)

  skullTexture:SetPoint("LEFT", container, "LEFT")
  mainText:SetPoint("LEFT", skullTexture, "RIGHT", 2, 0)
  levelText:SetPoint("LEFT", mainText, "RIGHT", 3, 0)
end

---@param toast Frame
---@param class string
---@return Frame
function _DeathToast:AddClassIcon(toast, class)
  local classIconFrame = CreateFrame("Frame", nil, toast, "BackdropTemplate")
  classIconFrame:SetSize(47.5, 47)
  classIconFrame:SetPoint("LEFT", toast, "LEFT", 8, 0)
  classIconFrame:SetBackdrop({
    bgFile = nil,
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
  })
  classIconFrame:SetBackdropBorderColor(0.639, 0.208, 0.933, 1) -- Purple (Epic)

  local classIcon = classIconFrame:CreateTexture(nil, "ARTWORK")
  classIcon:SetTexture("Interface\\Addons\\Reaper\\Icons\\" .. class)
  classIcon:SetSize(42, 42)
  classIcon:SetPoint("CENTER", classIconFrame, "CENTER", 0, 0)

  return classIconFrame
end
