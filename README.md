# meeseeks
AHK based live search for Path of Exile

# Info
Meseeks scrapes pathofexile.com/trade to check for items. The main purpose of this was to help find rare items. Yes, you can use live search on the site itself, or on poe.trade. I have personally missed out on more than one listing because I didn't notice the woop while in a delve. Meseeks shows a small dialog box as well as plays an alert sound. The alert can be replaced with any mp3 you like. Make sure it is in the same folder as the script, and you name it alert.mp3.

# Hotkeys
* CTRL-L Toggles settings (add or delete search items)
* CTRL-SHIFT-L Kills the script

# Configuration
Once you have launched the script, Meseeks will continue to search for your items. If you alter the settings, they will take affect after the script has finished searching for all items in the current list.

# Important
This requires AHK v 1.1+ in order to work. If you receive errors about an illegal character around `wb := ComObjCreate("InternetExplorer.Application") ; create a IE instance`, then you most likely have 1.0.x. 
In addition, this script requires Internet Explorer 11.0+ for it's web calls, any windows 10 system should have this by default. The script loads the requested pages in the background without a window. 
For any random errors, try to rerun the script as administrator to see if that resolves the issue. If it doesn't, please submit the error to issues with as much info as possible so I can try to resolve it.
