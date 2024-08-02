Reaper = Reaper or {}

---@class ToastManager
local ToastManager = {}
Reaper.ToastManager = ToastManager
ToastManager.__index = ToastManager

---@class DeathToast
local DeathToast = Reaper.DeathToast

-- Singleton
local instance

---@param limit number
---@return ToastManager
function ToastManager:new(limit)
  if instance then
    return instance
  end

  local self = setmetatable({}, ToastManager)
  self.toasts = {}
  self.limit = limit or 5
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

  for _, existingToast in ipairs(self.toasts) do
    local _, _, _, _, y = existingToast.toast:GetPoint()
    existingToast.toast:SetPoint("TOP", existingToast.toast:GetParent(), "TOP", 0, y + 72)
  end

  local toast = DeathToast:new(class, playerName, playerLevel, creatureName, creatureLevel)
  toast.toast:SetPoint("TOP", UIParent, "TOP", 0, -UIParent:GetHeight() / 4)
  table.insert(self.toasts, toast)

  toast.toast:ShowToast()
end

function ToastManager:flush()
  for _, toast in ipairs(self.toasts) do
    toast.toast:Hide()
  end
  self.toasts = {}
end