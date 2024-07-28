Reaper = Reaper or {}

---@class Rarity
local Rarity = {}
Reaper.Rarity = Rarity
Rarity.__index = Rarity

---@param self Rarity Instance
---@return string Tier
local function setTier(self)
  local level = self.playerLevel

  if level == 60 then
    return 'legendary'
  elseif level <= 59 and level >= 48 then
    return 'epic'
  elseif level <= 47 and level >= 34 then
    return 'rare'
  elseif level <= 33 and level >= 18 then
    return 'uncommon'
  else
    return 'common'
  end
end

---@param self Rarity Instance
---@return table RGB color
local function setColor(self)
  local tier = self.tier

  if tier == 'legendary' then
    return { red: 1, green: 0.502, blue: 0 }
  elseif tier == 'epic' then
    return { red: 0.639, green: 0.208, blue: 0.933 }
  elseif tier == 'rare' then
    return { red: 0, green: 0.439, blue: 0.867 }
  elseif tier == 'uncommon' then
    return { red: 0.118 , green: 1, blue: 0 }
  else
    return { red: 1, green: 1, blue: 1 }
  end
end

---@param level number Player level
---@return Rarity Instance
function Rarity:new(level)
  if type(level) ~= "number" then
    error("Player level must be a valid number.")
  end

  local self = setmetatable({}, Rarity)
  self.playerLevel = level
  self.tier = setTier(self)
  self.color = setColor(self)
  return self
end

---@return number Player level
function Rarity:getPlayerLevel()
  return self.playerLevel
end

---@return string Tier
function Rarity:getTier()
  return self.tier
end

---@return table RGB color
function Rarity:getColor()
  return self.color
end