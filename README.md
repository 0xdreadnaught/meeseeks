# meeseeks
AHK based live search for Path of Exile

# Info
Meeseeks scrapes pathofexile.com/trade to check for items. This is alternative to leaving whoop tabs open. 
When an item is found, not only is a sound played, but a dialog appears in the top right corner of the screen (covering the top part of the minimap) displaying the name of the item it found. The dialog also has buttons to either hide the alert or to delete the item from the search list entirely. If hide is chosen, the alert is suppressed until meeseeks loops around and starts checking the list from the beginning. Ctrl-L will bring up a dialog in the center of your screen asking if you would like to Add or Delete a search item. Selecting Add will open a series of two prompts asking for a name and then a URL. The name can be anything you like, something to easily identify that search item. Selecting Delete will display a list of all tracked search items. Check as many check boxes as yoe you want to remove, then click Delete. ALternatively, you can click View and meeseeks will open up each item in a browser tab using the system's default browser.

Meeseeks uses IE 11 as a comObject to query pathofexile.com/trade. This is done due to the vast difference in resource consumption versus something like Chrome or FireFox. For testing, I kept 2 live searches open with Gmail and Reddit open in two other tabs. After 30 minutes, Chrome was using almost 3GB of RAM, Firefox was using just over 1GB. The IE comObject uses roughly 70MB of RAM when it queries an item. As it only queries one item at a time, this keeps resource utilization to a minimum. Bandwidth consumption should also be pretty low since the official trade site doesn't have a lot of data on it. Unlike poe.trade, it doesn't contain clunky ads. poe.trade support may be added in the future, however it is low on the priority list. poe.trade gets access to stash API data on a delay, that kind of defeats the purpose of this tool.

# Hotkeys
* CTRL-L Toggles Add or Delete search items
* CTRL-SHIFT-L Kills the script

# Initial Setup
Using pathofexile.com/trade setup any search criteria you want and click search.
Copy the new URL
Press CTRL-L after starting meeseeks. 
Select Add
Enter the name you want to identify your search
Select OK
Paste the URL you copied
Select OK

Now you're good to go. Repeat the above steps as many times as you want. 

# Requirements
* This requires AHK v 1.1+ in order to work. 
  * If you receive errors about an illegal character around `wb := ComObjCreate("InternetExplorer.Application") ; create a IE instance`, then you most likely have 1.0.x. 
* Internet Explorer 11.0+ for it's web calls.
  * Any windows 10 system should have this by default.
  
# Notes
If you receive any error messages, please try to be as descriptive as possible, and/or send me a screenshot. I will do my best to resolve the issue and update the tool.

The sound of the alert can be altered if you want.
Line 111: SoundBeep, 200, 700
200 is the frequency, higher the number, higher the pitch
700 is the length in milliseconds

Line 110: ; SoundPlay, alert.mp3
This works on some systems and not on others. If you want to try this, kill meeseeks and comment out line 111 with a ;
Remove the ; from line 110 and rerun the script. I have found that this can result in either a working mp3p audio alert, an alert with no sound, or even triggering the alert. This is a weird issue with AHK that I am trying to resolve.
