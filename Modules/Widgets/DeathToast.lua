Reaper = Reaper or {}

---@class DeathToast
local DeathToast = {}
Reaper.DeathToast = DeathToast
DeathToast.__index = DeathToast

---@class Config
local Config = Reaper.Config

---@class Rarity
local Rarity = Reaper.Rarity

local function playSound()
  PlaySoundFile("Interface\\Addons\\Reaper\\Assets\\Sounds\\RaidWarning.ogg", "Master")
  PlaySoundFile("Interface\\Addons\\Reaper\\Assets\\Sounds\\UndeadMaleLaugh.ogg", "Master")
end

---@param self DeathToast
---@param playerLevel number
---@return toast Frame
local function createToast(self, playerLevel)
  local toast = CreateFrame("Frame", "CustomTooltip", UIParent, "BackdropTemplate")
  toast:Hide()

  toast:EnableMouse(true)
  toast:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" then
      self:Hide()
    end
  end)

  toast:SetSize(272, 64)

  toast:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
  })
  toast:SetBackdropColor(0, 0, 0, 1)

  local color = self.rarity:getColor()
  toast:SetBackdropBorderColor(color.red, color.green, color.blue)

  local fadeIn = toast:CreateAnimationGroup()
  local fadeOut = toast:CreateAnimationGroup()

  local fadeInAlpha = fadeIn:CreateAnimation("Alpha")
  fadeInAlpha:SetFromAlpha(0)
  fadeInAlpha:SetToAlpha(1)
  fadeInAlpha:SetDuration(0.2)
  fadeInAlpha:SetSmoothing("IN")

  local fadeOutAlpha = fadeOut:CreateAnimation("Alpha")
  local alertDuration = Config:Get("alertDuration")
  fadeOutAlpha:SetFromAlpha(1)
  fadeOutAlpha:SetToAlpha(0)
  fadeOutAlpha:SetDuration(0.5)
  fadeOutAlpha:SetStartDelay(alertDuration)
  fadeOutAlpha:SetSmoothing("OUT")

  fadeOut:SetScript("OnFinished", function()
    toast:Hide()
  end)

  toast.fadeIn = fadeIn
  toast.fadeOut = fadeOut

  toast.ShowToast = function()
    toast:Show()
    toast.fadeIn:Play()
    toast.fadeOut:Play()

    local soundEnabled = Config:Get("soundEnabled")
  
    if soundEnabled and playerLevel == 60 then
      playSound()
    end
  end

  return toast
end

---@param self DeathToast
---@param text string
---@param level number
local function addPlayerLabel(self, text, level)
  local container = CreateFrame("Frame", nil, self.toast)
    
  local levelText = container:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  levelText:SetText("(" .. level .. ")")

  local color = self.rarity:getColor()
  levelText:SetTextColor(color.red, color.green, color.blue)

  local mainText = container:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  mainText:SetText(text)

  local totalWidth = levelText:GetStringWidth() + mainText:GetStringWidth()

  local iconPaddingLeft = 8
  local iconPaddingRight = 8
  local iconWidth = self.classIcon:GetWidth() + iconPaddingLeft + iconPaddingRight

  container:SetSize(totalWidth, mainText:GetStringHeight())
    
  local toastWidth = self.toast:GetWidth()
  container:SetPoint("LEFT", self.classIcon, "RIGHT", (toastWidth - iconWidth - totalWidth) / 2 - iconPaddingRight, 10)
    
  levelText:SetPoint("LEFT", container, "LEFT")
  mainText:SetPoint("LEFT", levelText, "RIGHT", 3, 0)
end

---@param self DeathToast
---@param text string
local function addCreatureLabel(self, text)
  local container = CreateFrame("Frame", nil, self.toast)

  local mainText = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  mainText:SetText(text)
  mainText:SetTextColor(1, 0, 0)

  local skullTexture = container:CreateTexture(nil, "ARTWORK")
  skullTexture:SetTexture("Interface\\AddOns\\Reaper\\Assets\\Icons\\Skull")
  skullTexture:SetSize(16, 16)

  local totalWidth = skullTexture:GetWidth() + mainText:GetStringWidth() + 4

  local iconPaddingLeft = 8
  local iconPaddingRight = 8
  local iconWidth = self.classIcon:GetWidth() + iconPaddingLeft + iconPaddingRight

  container:SetSize(totalWidth, mainText:GetStringHeight())

  local toastWidth = self.toast:GetWidth()
  container:SetPoint("LEFT", self.classIcon, "RIGHT", (toastWidth - iconWidth - totalWidth) / 2 - iconPaddingRight, -10)

  skullTexture:SetPoint("LEFT", container, "LEFT")
  mainText:SetPoint("LEFT", skullTexture, "RIGHT", 2, 0)
end

---@param self DeathToast
---@param class string
---@return classIcon Frame
local function createClassIcon(self, class)
  local classIcon = CreateFrame("Frame", nil, self.toast, "BackdropTemplate")
  classIcon:SetSize(48, 48)
  classIcon:SetPoint("LEFT", self.toast, "LEFT", 8, 0)
  classIcon:SetBackdrop({
    bgFile = nil,
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
  })

  local color = self.rarity:getColor()
  classIcon:SetBackdropBorderColor(color.red, color.green, color.blue)

  local icon = classIcon:CreateTexture(nil, "ARTWORK")
  icon:SetTexture("Interface\\Addons\\Reaper\\Assets\\Icons\\Classes\\" .. class)
  icon:SetSize(42, 42)
  icon:SetPoint("CENTER", classIcon, "CENTER", 0, 0)

  return classIcon
end

---@param self DeathToast
local function addLegendaryDragon(self)
  local dragon = CreateFrame("Frame", nil, self.toast, "BackdropTemplate")
  dragon:SetSize(96, 96)
  dragon:SetPoint("TOPLEFT", self.toast, "TOPLEFT", -24, 12)

  local dragonTexture = dragon:CreateTexture(nil, "ARTWORK")
  dragonTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Gold-Dragon")
  dragonTexture:SetAllPoints(dragon)
  dragonTexture:SetDesaturated(true)

  local color = self.rarity:getColor()
  dragonTexture:SetVertexColor(color.red, color.green, color.blue)
end

---@param class string
---@param playerName string
---@param playerLevel number
---@param creatureName string
---@return DeathToast
function DeathToast:new(class, playerName, playerLevel, creatureName)
  Reaper:Print("DeathToast Created")

  local self = setmetatable({}, DeathToast)
  self.rarity = Rarity:new(playerLevel)
  self.toast = createToast(self, playerLevel)
  self.classIcon = createClassIcon(self, class)

  addPlayerLabel(self, playerName, playerLevel)
  addCreatureLabel(self, creatureName)

  if playerLevel == 60 then
    addLegendaryDragon(self)
  end

  return self
end