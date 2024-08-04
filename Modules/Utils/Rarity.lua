Reaper = Reaper or {}

---@class Rarity
local Rarity = {}
Reaper.Rarity = Rarity
Rarity.__index = Rarity

---@param self Rarity
---@param level number
---@return string
local function setTier(self, level)
  if level == 60 then
    return "legendary"
  elseif level <= 59 and level >= 48 then
    return "epic"
  elseif level <= 47 and level >= 34 then
    return "rare"
  elseif level <= 33 and level >= 18 then
    return "uncommon"
  elseif level <= 17 and level >= 10 then
    return "common"
  else
    return "poor"
  end
end

---@param self Rarity
---@return table
local function setColor(self)
  local tier = self.tier

  if tier == "legendary" then
    return { red = 1, green = 0.502, blue = 0 }
  elseif tier == "epic" then
    return { red = 0.639, green = 0.208, blue = 0.933 }
  elseif tier == "rare" then
    return { red = 0, green = 0.439, blue = 0.867 }
  elseif tier == "uncommon" then
    return { red = 0.118 , green = 1, blue = 0 }
  elseif tier == "common" then
    return { red = 1, green = 1, blue = 1 }
  else
    return { red = 0.616, green = 0.616, blue = 0.616 }
  end
end

---@param level number
---@return Rarity
function Rarity:new(level)
  if type(level) ~= "number" then
    error("Player level must be a valid number.")
  end

  local self = setmetatable({}, Rarity)
  self.tier = setTier(self, level)
  self.color = setColor(self)
  return self
end

---@return string
function Rarity:getTier()
  return self.tier
end

---@return table
function Rarity:getColor()
  return self.color
end