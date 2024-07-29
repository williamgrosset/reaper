Reaper = Reaper or {}

---@class ToastManager
local ToastManager = {}
Reaper.ToastManager = ToastManager
ToastManager.__index = ToastManager

---@class DeathToast
local DeathToast = Reaper.DeathToast

---@param limit number
---@return ToastManager
function ToastManager:new(limit)
  local self = setmetatable({}, ToastManager)
  self.toasts = {}
  self.limit = limit or 5
  self.startPosition = { x = 0, y = -UIParent:GetHeight() / 4 }
  return self
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

  for _, existingToast in ipairs(self.toasts) do
    local _, _, _, _, y = existingToast.toast:GetPoint()
    existingToast.toast:SetPoint("TOP", existingToast.toast:GetParent(), "TOP", 0, y + 72)
  end

  local toast = DeathToast:new(class, playerName, playerLevel, creatureName, creatureLevel)
  toast.toast:SetPoint("TOP", UIParent, "TOP", self.startPosition.x, self.startPosition.y)
  table.insert(self.toasts, toast)

  toast.toast:ShowToast()
end