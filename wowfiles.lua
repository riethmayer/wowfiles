local indicators = {}
local buffs = {}
local _, unit = UnitClass("player");

local classBuffs = {
   DRUID       = { "Mark of the Wild" },
   PRIEST      = { "Power Word: Fortitude" },
   MAGE        = { "Arcane Brilliance" },
   MONK        = { "Legacy of the White Tiger", "Legacy of the Emperor" },
   DEATHKNIGHT = { "Horn of Winter" },
   PALADIN     = { "Blessing of Kings", "Blessing of Might" },
   WARLOCK     = { "Dark Intent" },
   WARRIOR     = { "Battle Shout", "Commanding Shout" }
}

for i, buff in ipairs(classBuffs[unit]) do
   buffs[buff] = true
end

local getIndicator = function(frame)
   local indicator = indicators[frame:GetName()]
   if not indicator then
      indicator = CreateFrame("Button", nil, frame, "CompactAuraTemplate")
      indicator:ClearAllPoints()
      indicator:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -2)
      indicator:SetSize(22, 22)
      indicator:SetAlpha(0.6)
      indicators[frame:GetName()] = indicator
   end
   return indicator
end

local updateBuffs = function(frame)
   if not frame:IsVisible() then return end

   local indicator = getIndicator(frame)
   local buffName = nil
   for i = 1, 40 do
      local _, _, _, _, _, _, _, unit, _, _, _, _ = UnitBuff(frame.displayedUnit, i);
      buffName = UnitBuff(frame.displayedUnit, i);
      if not buffName then break end
      if buffs[buffName] and ( unit == "player" or unit == "pet" ) then
         indicator:SetSize(frame.buffFrames[1]:GetSize())
         CompactUnitFrame_UtilSetBuff(indicator, frame.displayedUnit, i, nil);
         return
      end
   end
   indicator:Hide()
end

local hideGryphons = function()
   MainMenuBarLeftEndCap:Hide()
   MainMenuBarRightEndCap:Hide()
   print("Gryphons hidden")
end

-- Hide Hotkey on action bars
local hideHotkeysOnActionbars = function()
   local r = {"MultiBarBottomLeft", "MultiBarBottomRight", "Action", "MultiBarLeft", "MultiBarRight"}
   for b=1,#r do
      for i=1,12 do
         _G[r[b].."Button"..i.."HotKey"]:SetAlpha(0)
      end
   end
   print("Hotkeys hidden")
end

local positionUnitFrames = function()
   PlayerFrame:SetPoint("topleft", 500, -300)
   RuneButtonIndividual1:SetScale("1.4")
   RuneButtonIndividual2:SetScale("1.4")
   RuneButtonIndividual3:SetScale("1.4")
   RuneButtonIndividual4:SetScale("1.4")
   RuneButtonIndividual5:SetScale("1.4")
   RuneButtonIndividual6:SetScale("1.4")
   RuneButtonIndividual1:SetPoint("topleft", -30, 60)
   TargetFrame:SetPoint("topleft", 725, -300)
   FocusFrame:SetPoint("topleft", 1025, -300)
   print("UnitFrames positioned")
end

local main = function()
   hideGryphons()
   hideHotkeysOnActionbars()
   positionUnitFrames()
   hooksecurefunc("CompactUnitFrame_UpdateBuffs", updateBuffs)
end

local defaultsFrame = CreateFrame("frame")
defaultsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
defaultsFrame:SetScript("OnEvent", function(self)
                           main()
end)
