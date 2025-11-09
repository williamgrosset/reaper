--[[
  Simplified Death Notification Handler
  Uses only Blizzard's native HARDCORE_DEATHS event
]]--

Reaper = Reaper or {}

---@class DeathNotificationHandler
local DeathNotificationHandler = {}
Reaper.DeathNotificationHandler = DeathNotificationHandler

-- Callback functions registered by other addons/modules
local hook_on_entry_functions = {}

-- Cache to prevent duplicate death alerts
local death_alert_cache = {}

-- Environment damage types (for backwards compatibility)
local ENVIRONMENT_DAMAGE = {
  [-2] = "Drowning",
  [-3] = "Falling",
  [-4] = "Fatigue",
  [-5] = "Fire",
  [-6] = "Lava",
  [-7] = "Slime",
}

---@class PlayerDeathData
---@field name string Player's name
---@field level number Player's level
---@field source_name string Name of creature/environment that killed the player
---@field source_id number|nil ID of creature that killed the player (optional, for backwards compatibility)
---@field class_id number|nil Class ID of the player (optional, parsed from Blizzard event if possible)
---@field location string|nil Location where the player died (may be present for environment damage)
---@field date number Unix timestamp of death
local function PlayerDeathData(name, level, source_name, source_id, class_id, location, date)
  return {
    name = name,
    level = level,
    source_name = source_name,
    source_id = source_id,
    class_id = class_id,
    location = location,
    date = date or time(),
  }
end

---Register a callback to be called when a death notification is received
---@param callback function Function that takes a PlayerDeathData object
function DeathNotificationHandler.HookOnNewEntry(callback)
  if type(callback) ~= "function" then
    error("DeathNotificationHandler.HookOnNewEntry: callback must be a function")
  end
  table.insert(hook_on_entry_functions, callback)
end

---Trigger all registered callbacks with death data
---@param player_data PlayerDeathData
local function triggerCallbacks(player_data)
  for _, callback in ipairs(hook_on_entry_functions) do
    local success, err = pcall(callback, player_data)
    if not success then
      print("Reaper: Error in death notification callback:", err)
    end
  end
end

---Parse Blizzard's HARDCORE_DEATHS message
---Expected format: "[PlayerName] has been slain by a CreatureName in ZoneName! They were level 12"
---Or environment damage: "[PlayerName] drowned to death in ZoneName! They were level 12"
---                       "[PlayerName] fell to their death in ZoneName! They were level 12"
---                       "[PlayerName] burned to death in ZoneName! They were level 12"
---                       etc.
---@param msg string The death message from Blizzard
---@return PlayerDeathData|nil
local function parseBlizzardDeathMessage(msg)
  if not msg or msg == "" then
    return nil
  end

  -- Extract player name from [brackets]
  local _, bracket_content = string.split("[", msg)
  if not bracket_content then
    return nil
  end
  
  local player_name, rest = string.split("]", bracket_content)
  if not player_name or not rest then
    return nil
  end

  -- Extract level
  local level_start, level_end = string.find(msg, "level ")
  local level = nil
  if level_end then
    local level_str = string.sub(msg, level_end + 1)
    level = tonumber(level_str)
  end

  if not level then
    return nil
  end

  -- Determine death source and location
  local source_name = "Unknown"
  local source_id = nil -- Optional, for backwards compatibility
  local location = nil
  
  -- Check for drowning
  local drowned_start = string.find(msg, "drowned")
  if drowned_start then
    source_name = ENVIRONMENT_DAMAGE[-2]
    source_id = -2
    
    -- Extract location for drowning (between "in " and "! They were")
    local in_start = string.find(msg, " in ", drowned_start)
    if in_start then
      local they_were_start = string.find(msg, "! They were", in_start)
      if they_were_start then
        location = string.sub(msg, in_start + 4, they_were_start - 1)
      end
    end
  else
    -- Check for "has been slain by a"
    local slain_start, slain_end = string.find(msg, "has been slain by a ")
    if slain_start and slain_end then
      -- Extract creature name (between "by a " and " in ")
      local in_start = string.find(msg, " in ", slain_end)
      if in_start then
        source_name = string.sub(msg, slain_end + 1, in_start - 1)
        
        -- Extract location (between " in " and "! They were")
        local they_were_start = string.find(msg, "! They were", in_start)
        if they_were_start then
          location = string.sub(msg, in_start + 4, they_were_start - 1)
        end
        
        -- Optionally try to look up the creature ID for backwards compatibility
        if npc_to_id and npc_to_id[source_name] then
          source_id = npc_to_id[source_name]
        end
      end
    else
      -- Check for falling
      local fell_start = string.find(msg, "fell to")
      if fell_start then
        source_name = ENVIRONMENT_DAMAGE[-3]
        source_id = -3
        
        -- Extract location for falling (between "in " and "! They were")
        local in_start = string.find(msg, " in ", fell_start)
        if in_start then
          local they_were_start = string.find(msg, "! They were", in_start)
          if they_were_start then
            location = string.sub(msg, in_start + 4, they_were_start - 1)
          end
        end
      else
        -- Check for other environment damage types
        -- Fire: "burned to death"
        local burned_start = string.find(msg, "burned")
        if burned_start then
          source_name = ENVIRONMENT_DAMAGE[-5]
          source_id = -5
          
          local in_start = string.find(msg, " in ", burned_start)
          if in_start then
            local they_were_start = string.find(msg, "! They were", in_start)
            if they_were_start then
              location = string.sub(msg, in_start + 4, they_were_start - 1)
            end
          end
        else
          -- Lava: "melted in lava"
          local melted_start = string.find(msg, "melted")
          if melted_start then
            source_name = ENVIRONMENT_DAMAGE[-6]
            source_id = -6
            
            local in_start = string.find(msg, " in ", melted_start)
            if in_start then
              local they_were_start = string.find(msg, "! They were", in_start)
              if they_were_start then
                location = string.sub(msg, in_start + 4, they_were_start - 1)
              end
            end
          else
            -- Fatigue: "died from fatigue"
            local fatigue_start = string.find(msg, "fatigue")
            if fatigue_start then
              source_name = ENVIRONMENT_DAMAGE[-4]
              source_id = -4
              
              local in_start = string.find(msg, " in ", fatigue_start)
              if in_start then
                local they_were_start = string.find(msg, "! They were", in_start)
                if they_were_start then
                  location = string.sub(msg, in_start + 4, they_were_start - 1)
                end
              end
            else
              -- Slime: "slimed"
              local slime_start = string.find(msg, "slime")
              if slime_start then
                source_name = ENVIRONMENT_DAMAGE[-7]
                source_id = -7
                
                local in_start = string.find(msg, " in ", slime_start)
                if in_start then
                  local they_were_start = string.find(msg, "! They were", in_start)
                  if they_were_start then
                    location = string.sub(msg, in_start + 4, they_were_start - 1)
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  return PlayerDeathData(player_name, level, source_name, source_id, nil, location, time())
end

---Handle the HARDCORE_DEATHS event
---@param msg string The death message
local function onHardcoreDeaths(msg)
  -- Hide the raid warning frame (Blizzard shows this automatically)
  if _G["RaidWarningFrameSlot1"] then
    _G["RaidWarningFrameSlot1"]:SetText("")
  end
  if _G["RaidWarningFrameSlot2"] then
    _G["RaidWarningFrameSlot2"]:SetText("")
  end

  -- Parse the death message
  local death_data = parseBlizzardDeathMessage(msg)
  
  if not death_data then
    return
  end

  -- Check if we've already processed this death (prevent duplicates)
  local cache_key = death_data.name .. "-" .. death_data.level
  if death_alert_cache[cache_key] then
    return
  end
  
  -- Mark as processed
  death_alert_cache[cache_key] = time()

  -- Trigger all registered callbacks
  triggerCallbacks(death_data)
end

---Initialize the death notification handler
function DeathNotificationHandler:initialize()
  -- Create event handler frame
  local frame = CreateFrame("Frame", "ReaperDeathNotificationFrame")
  
  -- Register for Blizzard's native hardcore death event
  frame:RegisterEvent("HARDCORE_DEATHS")
  
  -- Set up event handler
  frame:SetScript("OnEvent", function(self, event, ...)
    if event == "HARDCORE_DEATHS" then
      local msg = ...
      onHardcoreDeaths(msg)
    end
  end)

  -- Join the HardcoreDeaths channel after a delay
  -- Channels aren't immediately available at PLAYER_LOGIN, so we delay by 3 seconds
  C_Timer.After(3.0, function()
    -- Join the HardcoreDeaths channel to receive death notifications
    local channelIndex = JoinChannelByName("HardcoreDeaths")
    
    -- Enable hardcore death alerts (CVar: 2 = enable channel notifications)
    SetCVar("hardcoreDeathAlertType", 2)
    
    if channelIndex and channelIndex > 0 then
      -- Successfully joined the channel
      -- Hide it from all chat frames to reduce clutter
      for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
          ChatFrame_RemoveChannel(chatFrame, "HardcoreDeaths")
        end
      end
    else
      print("Reaper: Warning - Could not join HardcoreDeaths channel. Death notifications may not work.")
    end
  end)
  
  -- Clean up old cache entries periodically (every 5 minutes)
  C_Timer.NewTicker(300, function()
    local current_time = time()
    local cutoff_time = current_time - 3600 -- Keep for 1 hour
    
    for key, timestamp in pairs(death_alert_cache) do
      if timestamp < cutoff_time then
        death_alert_cache[key] = nil
      end
    end
  end)
end

return DeathNotificationHandler