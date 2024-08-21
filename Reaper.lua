---@class Reaper
Reaper = Reaper or {}

---@class Init
local Init = Reaper.Init

local loadingFrame = CreateFrame("Frame")
Reaper.loadingFrame = loadingFrame

loadingFrame:RegisterEvent("ADDON_LOADED")

loadingFrame:SetScript("OnEvent", function(self, event, arg1, ...)
  if (event == "ADDON_LOADED") and (arg1 == "Reaper") then
    Init:onAddonLoaded()
    self:RegisterEvent("PLAYER_LOGIN")
  end

  if (event == "PLAYER_LOGIN") then
    Init:onPlayerLogin()
  end
end)

---@param message string
function Reaper:print(message)
  print("|cFF765bff[Reaper]|r " .. message)
end