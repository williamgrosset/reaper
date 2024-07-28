Reaper = Reaper or {}

---@class DeathToast
local DeathToast = {}
Reaper.DeathToast = DeathToast
DeathToast.__index = DeathToast

---@param self DeathToast
local function createToast(self)
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

  self.toast = toast
end

---@param self DeathToast
---@param text string
---@param text string
local function addPlayerLabel(self, text, level)
  local container = CreateFrame("Frame", nil, self.toast)
    
  local mainText = container:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  mainText:SetText(text)

  local levelText = container:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  levelText:SetText(level)
  levelText:SetTextColor(0.639, 0.208, 0.933) -- Purple (Epic)

  local totalWidth = mainText:GetStringWidth() + levelText:GetStringWidth()

  local iconPaddingLeft = 8
  local iconPaddingRight = 8
  local iconWidth = self.classIcon:GetWidth() + iconPaddingLeft + iconPaddingRight

  container:SetSize(totalWidth, mainText:GetStringHeight())
    
  local toastWidth = self.toast:GetWidth()
  container:SetPoint("LEFT", self.classIcon, "RIGHT", (toastWidth - iconWidth - totalWidth) / 2 - iconPaddingRight, 10)
    
  mainText:SetPoint("LEFT", container, "LEFT")
  levelText:SetPoint("LEFT", mainText, "RIGHT", 3, 0)
end

---@param self DeathToast
---@param text string
---@param text string
local function addCreatureLabel(self, text, level)
  local container = CreateFrame("Frame", nil, self.toast)

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
  local iconWidth = self.classIcon:GetWidth() + iconPaddingLeft + iconPaddingRight

  container:SetSize(totalWidth, mainText:GetStringHeight())

  local toastWidth = self.toast:GetWidth()
  container:SetPoint("LEFT", self.classIcon, "RIGHT", (toastWidth - iconWidth - totalWidth) / 2 - iconPaddingRight, -10)

  skullTexture:SetPoint("LEFT", container, "LEFT")
  mainText:SetPoint("LEFT", skullTexture, "RIGHT", 2, 0)
  levelText:SetPoint("LEFT", mainText, "RIGHT", 3, 0)
end

---@param self DeathToast
---@param class string
local function addClassIcon(self, class)
  local classIconFrame = CreateFrame("Frame", nil, self.toast, "BackdropTemplate")
  classIconFrame:SetSize(47.5, 47)
  classIconFrame:SetPoint("LEFT", self.toast, "LEFT", 8, 0)
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

  self.classIcon = classIconFrame
end

---@return DeathToast
function DeathToast:new()
  local self = setmetatable({}, DeathToast)
  self.toast = nil
  self.classIcon = nil
  return self
end

---@param playerName string
---@param guildName string
---@param classId number
---@param playerLevel number
---@param creatureId number
---@param zoneId number
function DeathToast:Create(playerName, guildName, classId, playerName, creatureId, zoneId)
  print("DeathToast Created")

  -- Dummy example
  createToast(self)
  addClassIcon(self, "Druid")
  addPlayerLabel(self, "Rolandmartin", "(51)")
  addCreatureLabel(self, "Boar", "(61)")

  self.toast:Show()
end