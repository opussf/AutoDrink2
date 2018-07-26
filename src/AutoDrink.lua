
-- AutoDrink by Jordon
-- Personalized by OpusSF

local AutoDrink = CreateFrame("Button", "AutoDrink", UIParent, "SecureActionButtonTemplate")
AutoDrink:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
AutoDrink:SetAttribute("type", "macro");
AutoDrink:SetAttribute("macrotext", "/run AutoDrink:Update()");
local AutoDrinks = {}

AutoDrink:RegisterEvent("PLAYER_ENTERING_WORLD")
function AutoDrink:PLAYER_ENTERING_WORLD()
	local macroIndex = GetMacroIndexByName("AutoDrink")  -- returns 0 or index of first macro that matches
	if macroIndex == 0 then -- no macro found
		DEFAULT_CHAT_FRAME:AddMessage("no macro found")
		-- Max 36 macros per account
		-- 36 is out of Date.  The first 120 macros are global, 121 starts the personal macros.
		if GetNumMacros() == 36 then
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99AutoDrink|r: |cffff0000WARNING|r: Unable to create macro. Please free up a macro slot and reload your UI.")
			return
		end
		createdIndex = CreateMacro("AutoDrink", "INV_MISC_QUESTIONMARK", "#showtooltip\n/AutoDrink Conjured Mana Fritter, Conjured Mana Pudding, Ley-Enriched Water, Highmountain Spring Water\n/click AutoDrink", 1)
		-- CreateMacro("name", icon, "body", perCharacter, isLocal)
	elseif macroIndex and macroIndex <= 120 then
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99AutoDrink|r: |cffff0000WARNING|r: The macro is set as GLOBAL. Please consider moving to perCharacter")
	end
	self:Fetch()
end

function AutoDrink:Fetch()
	-- Try to fetch the list from the macro
	local list = select(3, GetMacroInfo("AutoDrink"))
	if not list then return end
	list = string.match(list, "/AutoDrink (.-)\n")
	if list then
		SlashCmdList.AutoDrink(list)
	end
end

SLASH_AutoDrink1 = "/AutoDrink"
function SlashCmdList.AutoDrink(list)
	AutoDrinks = {}
	for drink in string.gmatch(list, '[^,]+') do
		drink = drink:gsub("^%s*(.-)%s*$", "%1")
	    table.insert(AutoDrinks, drink)
	end
	AutoDrink:BAG_UPDATE()
end

function AutoDrink:Update()
	if UnitAffectingCombat("player") or not self.drink then return end
	local isDrinking = false
	for an=1,40 do
		local uName = UnitAura( "player", an )
		if uName == "Drink" or uName == "Refreshment" then  -- @TODO:  Localize this?
			isDrinking = true
		end
	end
	if isDrinking then
		self:SetAttribute("macrotext", "/run AutoDrink:Update()")
	else
		self:SetAttribute("macrotext", "/run AutoDrink:Update()\n/use " .. self.drink)
	end
end

AutoDrink:RegisterEvent("BAG_UPDATE")
function AutoDrink:BAG_UPDATE()
	for i=1, #AutoDrinks do
		if GetItemCount(AutoDrinks[i]) > 0 then
			self.drink = AutoDrinks[i]
			if not UnitAffectingCombat("player") then
				SetMacroItem("AutoDrink", AutoDrinks[i])
				self:Update()
			end
			break
		end
	end
end

-- Refresh macro icon
LoadAddOn("Blizzard_MacroUI")
hooksecurefunc("MacroFrame_SaveMacro", function() AutoDrink:Fetch() AutoDrink:BAG_UPDATE() end)
