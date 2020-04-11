


    NOCOMBAT CreateMacro("name", icon, "body", perCharacter, isLocal) - Create a new macro. (nocombat 2.0)
    CursorHasMacro() - Returns 1 if the cursor is currently dragging a macro. (added 2.0.3)
    DeleteMacro(id or "name") - Deletes a macro.
    NOCOMBAT EditMacro(index, "name", iconIndex, "body", isLocal, perCharacter) - Saves a macro. (nocombat 2.0)
    GetMacroBody(id or "name") - Returns the body (macro text) of a macro.
    GetMacroIconInfo(index) - Returns texture of the icons provided by Blizzard.
name, link = GetMacroItem(index) or GetMacroItem("name")
    GetMacroItemIconInfo(index) - Returns texture of the item icons provided by Blizzard
macroIndex =  GetMacroIndexByName("name") - Returns macro index.



    GetMacroInfo(id or "name") - Returns "name", "iconTexture", "body", isLocal.
    GetNumMacroIcons() - Returns the number of usable icons provided by Blizzard.
    GetNumMacroItemIcons() - Returns the number of usable item icons provided by Blizzard.
    GetNumMacros() - Returns the number of macros the user has.
    PickupMacro(id or "name") - Pickup a macro button icon.
    PROTECTED RunMacro(id or "name") - Runs a macro.
    PROTECTED RunMacroText("macro") - Interpret the given string as a macro and run it.
    SecureCmdOptionParse("command") - Used for evaluating conditionals in macros, returning the appropriate choice.
    PROTECTED StopMacro() - Stops the currently executing macro.



    IsUsableItem(item) - Returns usable, noMana.
    IsConsumableItem(item)
    IsCurrentItem(item)

name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(index, "bookType") or GetSpellInfo("name") or GetSpellInfo(id)

name, rank = GetItemSpell(itemID) or GetItemSpell("itemName") or GetItemSpell("itemLink")



/dump GetItemSpell( 113509 )  -- "Refreshment"  --Conjured Mana Bun
/dump GetItemSpell( 133575 )  -- "Food & Drink" --Dried Mackerel Strips

/dump GetSpellInfo( "Refreshment" )

/dump GetSpellInfo( GetItemSpell( 113509 ) )


/dump GetItemInfo( 113509 )
 1 = name
 2 = Link
 3 = quality
 4 = iLevel
 5 = reqLevel
 6 = class
 7 = subclass
 8 = maxStack
 9 = equipSlot
10 = texture
11 = vendorPrice




Add a 'WellFed' list or 'buff' list of buff foods.
Eat the buff foods if not buffed, eat the normal foods if buffed.


# current issues
I feel like the current issue is 'poor' configuration.
The configuration is in the macro, with text for foods.
IMHO this clutters the macro.

On the pro side, it keeps it super simple.

# Improvements

1) Move the food lists to another macro (AutoDrinkInit).
    *) Scan this macro at start up for lists.
    *) AutoDrink macro needs only be "/click AutoDrink"
    *) Pros
        *) Fewer characters in the main macro, can do more roleplay sort of stuff
        *) Only need to run /AutoDrink and /AutoBuff to init the addon data, or when they change.
            -) probably does not even need to be run.
            -) No need for "#showtooltip" in init macro
        *) Keeps it simple
    *) Cons
        *) User needs to allocate another macro slot.
        *) User needs to remember to use the init macro to change lists
2) Remove the in-macro config.
    *) Save the lists, for each character
    *) Pros
        *) food lists saved in addon
        *) Much smaller default macro footprint.
    *) Cons
        *) Forces the user to update the lists
        *) May require more code / user interaction to control lists
        *) The user would probably just set this up in teh macro anyway
3) Command line food list management.
    *) Save the lists, for each character
    *) Use commands to manage the lists
        *) /AutoDrink(Buff) <list> would act as it does now.
        *) insert <slot> <list> would insert the list at the slot position
        *) list would show the list of foods, in order
        *) rm <slot list> would remove foods from those slots (work from the rear, or gather first)
        *) clear would clear the list
    *) Pros
        *) Much smaller default macro footprint
        *) Can use links in lists
        *) Longer lists are possible
    *) Cons
        *) Food lists not apparent, not as simple as updating
