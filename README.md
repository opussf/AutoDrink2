# AutoDrink - Personalized

This is a great addon.
It suffers only from putting the macro in the General Macros tab.
This makes it hard to use with many alts.

## Personalized

This modification creates the new macro in the personal tab.

## Bugs / Work arounds / issues

The WoW Macro API is a bit limited.
The GetMacroIndexByName("name") only returns the first macro index number.
If there are 2 macros by the same name (general and personal), then only the index of the general macro is returned.
Since this addon updates the macro info, the API index limitation makes having a general macro for most characters, and a specific macro for a few toons, nearly impossible.

## Future updates / ideas

1. Create a general macro (AutoDrinkGeneral).  Which is also updated, and can be used.
