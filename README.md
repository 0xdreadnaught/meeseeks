# meeseeks
AHK based live search for Path of Exile

# Info
Meeseeks scrapes pathofexile.com/trade to check for items. This is alternative to leaving whoop tabs open. The alert is also far more noticable than a standard whoop. This is mainly for people who listen to music or have netflix open while playing. When am item is found an audio alert will play, additionaly meeseeks will create a popup window with "OK/Delete" options. "OK" will just close the window, it will reappear when the loop gets back to searching for that item again. "Delete" will remove the search item from searches.txt and resume searching for other items. The alert sounds can be replaced with any mp3 you like, just ensure the name is changed to alert.mp3 and place it in the same folder as meeseeks.ahk.

# Hotkeys
* CTRL-L Toggles settings (add or delete search items)
* CTRL-SHIFT-L Kills the script

# Configuration
To add an item, press CTRL-SHIFT-L after starting meeseeks. Two boxes will appear asking for a name, and then a url.

# Requirements
* This requires AHK v 1.1+ in order to work. 
  * If you receive errors about an illegal character around `wb := ComObjCreate("InternetExplorer.Application") ; create a IE instance`, then you most likely have 1.0.x. 
* Internet Explorer 11.0+ for it's web calls.
  * Any windows 10 system should have this by default.
  
# Notes
The script loads the requested pages in the background without a window. For any random errors, try to rerun the script as administrator to see if that resolves the issue. If it doesn't, please submit the error under issues with as much info as possible so I can try to resolve it.
