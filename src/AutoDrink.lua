
-- AutoDrink by Jordon
-- Personalized by OpusSF

local AutoDrink = CreateFrame("Button", "AutoDrink", UIParent, "SecureActionButtonTemplate")
AutoDrink:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
AutoDrink:SetAttribute("type", "macro");
AutoDrink:SetAttribute("macrotext", "/run AutoDrink:Update()");

local AURAS = { ["Drink"] = true, ["Food"] = true, ["Refreshment"] = true, ["Food & Drink"] = true }

local AutoDrinks = {}
local AutoBuffs = {}

AutoDrink:RegisterEvent("PLAYER_ENTERING_WORLD")
function AutoDrink:PLAYER_ENTERING_WORLD()
	local macroIndex = GetMacroIndexByName("AutoDrink")  -- returns 0 or index of first macro that matches
	if macroIndex == 0 then -- no macro found
		DEFAULT_CHAT_FRAME:AddMessage("no macro found")
		-- Max 36 macros per account
		-- 36 is out of Date.  The first 120 macros are global, 121 starts the personal macros.
		-- 18 max personal macros
		if select( 2, GetNumMacros() ) == 18 then
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99AutoDrink|r: |cffff0000WARNING|r: Unable to create macro. Please free up a macro slot and reload your UI.")
			return
		end
		createdIndex = CreateMacro("AutoDrink", "INV_MISC_QUESTIONMARK", "#showtooltip\n/AutoDrink Conjured Mana Fritter, Conjured Mana Pudding, Ley-Enriched Water, Highmountain Spring Water\n/AutoBuff\n/click AutoDrink", 1)
		-- CreateMacro("name", icon, "body", perCharacter, isLocal)
	elseif macroIndex and macroIndex <= 120 then
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99AutoDrink|r: |cffff0000WARNING|r: The macro is set as GLOBAL. Copying to your specific macros.")
		local macroBody = select( 3, GetMacroInfo( "AutoDrink" ) ) -- macro body with \n between lines....
		createdIdex = CreateMacro( "AutoDrink", "INV_MISC_QUESTIONMARK", macroBody, 1 )  -- 1  makes it personal
	end
	self:Fetch()
end

function AutoDrink:Fetch()
	-- Try to fetch the list from the macro
	local macrotext = select(3, GetMacroInfo("AutoDrink"))
	if macrotext then
		list = string.match(macrotext, "/AutoDrink (.-)\n")
		if list then
			SlashCmdList.AutoDrink(list)
		end
		list = string.match(macrotext, "/AutoBuff (.-)\n")
		if list then
			SlashCmdList.AutoBuff(list)
		end
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

SLASH_AutoBuff1 = "/AutoBuff"
function SlashCmdList.AutoBuff( list )
	AutoBuffs = {}
	for drink in string.gmatch( list, '[^,]+' ) do
		drink = drink:gsub( "^%s*(.-)%s*$", "%1" )
		table.insert( AutoBuffs, drink )
	end
	AutoDrink:BAG_UPDATE()
end

function AutoDrink:HasWellFed()
	for an=1,40 do
		local uName = UnitAura( "player", an )
		if uName == "Well Fed" then
			return true
		end
	end
end

function AutoDrink:Update()
	if( not UnitAffectingCombat( "player" ) and ( self.drink or self.buff ) ) then
		local isDrinking = false
		for an=1,40 do
			local uName = UnitAura( "player", an )
			if AURAS[uName] then
				isDrinking = true
			end
		end
		if isDrinking then
			self:SetAttribute("macrotext", "/run AutoDrink:Update()")
		else
--[[
	if you have the well fed, and you have food, use the food
	if you are not  well fed, and you have buff, use the buff
    if you have the well fed, and you don't have food, use the buff
    if you are not  well fed, and you don't have buff, use the food
]]
			self.use = ( AutoDrink:HasWellFed() and self.drink or self.buff ) or
					self.buff or self.drink

			if AutoDrink.debug then print( "Set the button to use: "..( self.use or "nil" ) ); end
			if self.use then
				self:SetAttribute("macrotext", "/run AutoDrink:Update()\n/use " ..self.use )
				SetMacroItem( "AutoDrink", self.use )
			end
		end
	end
end

AutoDrink:RegisterEvent("BAG_UPDATE")
function AutoDrink:BAG_UPDATE()
	self.drink = nil
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
	self.buff = nil
	for i=1, #AutoBuffs do
		if GetItemCount( AutoBuffs[i] ) > 0 then
			self.buff = AutoBuffs[i]
			if not UnitAffectingCombat("player") and not AutoDrink:HasWellFed() then
				SetMacroItem( "AutoDrink", AutoBuffs[i] )
				self:Update()
			end
			break
		end
	end
end
AutoDrink:RegisterEvent( "UNIT_AURA" )
function AutoDrink:UNIT_AURA( unit )
	if( unit == "player" ) then
		AutoDrink:Update()
	end
end

-- Refresh macro icon
LoadAddOn("Blizzard_MacroUI")
hooksecurefunc("MacroFrame_SaveMacro", function() AutoDrink:Fetch(); AutoDrink:BAG_UPDATE(); end)
