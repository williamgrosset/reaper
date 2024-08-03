Reaper = Reaper or {}

---@class ToastManager
local ToastManager = {}
Reaper.ToastManager = ToastManager
ToastManager.__index = ToastManager

---@class DeathToast
local DeathToast = Reaper.DeathToast

-- Singleton
local instance

local defaultAnchorPos = {
  x = 0,
  y = -UIParent:GetHeight() / 4
}

local function createAnchor()
  local anchor = CreateFrame("Frame", "ToastAnchorFrame", UIParent, "BackdropTemplate")
  anchor:Hide()
  anchor:SetSize(175, 50)
  anchor:SetPoint("TOP", UIParent, "TOP", defaultAnchorPos.x, defaultAnchorPos.y)

  anchor:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 12,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
  })

  anchor.texture = anchor:CreateTexture(nil, "BACKGROUND")
  anchor.texture:SetSize(36, 36)
  anchor.texture:SetPoint("LEFT", anchor, "LEFT", 10, 0)
  anchor.texture:SetTexture("Interface\\Addons\\Reaper\\Assets\\Icons\\Config\\Anchor")

  anchor.label = anchor:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  anchor.label:SetPoint("LEFT", anchor.texture, "RIGHT", 10, 0)
  anchor.label:SetText("Reaper Anchor")

  anchor.texture:SetPoint("CENTER", anchor, "CENTER", -60, 0)
  anchor.label:SetPoint("CENTER", anchor, "CENTER", 10, 0)

  anchor:SetMovable(true)
  anchor:EnableMouse(true)
  anchor:RegisterForDrag("LeftButton")
  anchor:SetScript("OnDragStart", anchor.StartMoving)
  anchor:SetScript("OnDragStop", anchor.StopMovingOrSizing)

  anchor:SetScript("OnMouseUp", function(self, button)
    if button == "RightButton" then
      local manager = ToastManager:GetInstance()
      manager:ToggleAnchorVisibility(false)
    end
  end)

  return anchor
end

---@param limit number
---@return ToastManager
function ToastManager:new(limit)
  if instance then
    return instance
  end

  local self = setmetatable({}, ToastManager)
  self.toasts = {}
  self.limit = limit or 5
  self.anchor = createAnchor()
  instance = self
  return instance
end

---@return ToastManager
function ToastManager:GetInstance()
  return instance
end

---@param limit number
---@return ToastManager
function ToastManager:Initialize(limit)
  instance = ToastManager:new(limit)
  return instance
end

---@param class string
---@param playerName string
---@param playerLevel number
---@param creatureName string
---@param creatureLevel number
function ToastManager:addToast(class, playerName, playerLevel, creatureName, creatureLevel)
  -- Remove oldest toast if we reached limit
  if #self.toasts >= self.limit then
    local oldestToast = table.remove(self.toasts, 1)
    oldestToast.toast:Hide()
  end

  for i, existingToast in ipairs(self.toasts) do
    local point, relativeTo, relativePoint, xOffset, yOffset = existingToast.toast:GetPoint()
    existingToast.toast:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset + 72)
  end

  local toast = DeathToast:new(class, playerName, playerLevel, creatureName, creatureLevel)
  toast.toast:SetPoint("TOP", self.anchor, "TOP", 0, 72)
  table.insert(self.toasts, toast)

  toast.toast:ShowToast()
end

function ToastManager:flush()
  for _, toast in ipairs(self.toasts) do
    toast.toast:Hide()
  end
  self.toasts = {}
end

function ToastManager:ToggleAnchorVisibility(show)
  if show == nil then
    if self.anchor:IsShown() then
      self.anchor:Hide()
    else
      self.anchor:Show()
    end
  elseif show then
    self.anchor:Show()
  else
    self.anchor:Hide()
  end
end

function ToastManager:ResetAnchor()
  self.anchor:ClearAllPoints()
  self.anchor:SetPoint("TOP", UIParent, "TOP", defaultAnchorPos.x, defaultAnchorPos.y)
end