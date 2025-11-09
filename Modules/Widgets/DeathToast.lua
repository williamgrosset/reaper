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
    self:Hide()
  end)

  toast:SetSize(320, 64)

  toast:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
  })
  toast:SetBackdropColor(0, 0, 0, 0.7)

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
  local alertDuration = Config:get("alertDuration")
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

  toast:SetScript("OnEnter", function(self)
    if fadeOut:IsPlaying() then
      fadeOut:Pause()
    end
  end)

  toast:SetScript("OnLeave", function(self)
    if fadeOut:IsPaused() then
      fadeOut:Play()
    end
  end)

  toast.ShowToast = function()
    toast:Show()
    toast.fadeIn:Play()
    toast.fadeOut:Play()

    local soundEnabled = Config:get("soundEnabled")
  
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
    
  local skullTexture = container:CreateTexture(nil, "ARTWORK")
  skullTexture:SetTexture("Interface\\AddOns\\Reaper\\Assets\\Icons\\Misc\\Skull")
  skullTexture:SetSize(16, 16)

  local levelText = container:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  levelText:SetText("(" .. level .. ")")

  local color = self.rarity:getColor()
  levelText:SetTextColor(color.red, color.green, color.blue)

  local mainText = container:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  mainText:SetText(text)

  local totalWidth = skullTexture:GetWidth() + mainText:GetStringWidth() + levelText:GetStringWidth() + 4

  container:SetSize(totalWidth, mainText:GetStringHeight())
    
  container:SetPoint("CENTER", self.toast, "CENTER", 0, 10)
    
  skullTexture:SetPoint("LEFT", container, "LEFT")
  mainText:SetPoint("LEFT", skullTexture, "RIGHT", 2, 0)
  levelText:SetPoint("LEFT", mainText, "RIGHT", 3, 0)
end

---@param self DeathToast
---@param text string
---@param location string|nil
local function addCreatureLabel(self, text, location)
  local container = CreateFrame("Frame", nil, self.toast)

  local mainText = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  mainText:SetText(text)
  mainText:SetTextColor(1, 0, 0)

  local skullTexture = container:CreateTexture(nil, "ARTWORK")
  skullTexture:SetTexture("Interface\\AddOns\\Reaper\\Assets\\Icons\\Misc\\Elite")
  skullTexture:SetSize(16, 16)

  local totalWidth = skullTexture:GetWidth() + mainText:GetStringWidth() + 4

  -- Add location if provided
  local locationText = nil
  local mapTexture = nil
  if location then
    mapTexture = container:CreateTexture(nil, "ARTWORK")
    mapTexture:SetTexture("Interface\\AddOns\\Reaper\\Assets\\Icons\\Misc\\Map")
    mapTexture:SetSize(16, 16)

    locationText = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    locationText:SetText(location)
    locationText:SetTextColor(0.8, 0.8, 0.8)

    totalWidth = totalWidth + 6 + mapTexture:GetWidth() + locationText:GetStringWidth() + 2
  end

  container:SetSize(totalWidth, mainText:GetStringHeight())

  container:SetPoint("CENTER", self.toast, "CENTER", 0, -10)

  skullTexture:SetPoint("LEFT", container, "LEFT")
  mainText:SetPoint("LEFT", skullTexture, "RIGHT", 2, 0)

  if location and mapTexture and locationText then
    mapTexture:SetPoint("LEFT", mainText, "RIGHT", 6, 0)
    locationText:SetPoint("LEFT", mapTexture, "RIGHT", 2, 0)
  end
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

---@param playerName string
---@param playerLevel number
---@param creatureName string
---@param location string|nil
---@return DeathToast
function DeathToast:new(playerName, playerLevel, creatureName, location)
  local self = setmetatable({}, DeathToast)
  self.rarity = Rarity:new(playerLevel)
  self.toast = createToast(self, playerLevel)

  addPlayerLabel(self, playerName, playerLevel)
  addCreatureLabel(self, creatureName, location)

  if playerLevel == 60 then
    addLegendaryDragon(self)
  end

  return self
end