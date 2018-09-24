; main search loop
Loop {
	wb := ComObjCreate("InternetExplorer.Application") ; create a IE instance
	wb.Visible := False
	wb.Navigate("https://www.pathofexile.com/trade/search/Delve/lYWW6uV") ; this exists
	; wb.Navigate("https://www.pathofexile.com/trade/search/Delve/LnqenlTn") ; this doesn't exist

	While wb.readyState != 4 || wb.document.readyState != "complete" || wb.busy || A_Index < 300 ; wait for the page to load
	Sleep, 10

	try {
		if wb.Document.GetElementsByClassName("itemBoxContent")[0].innertext
			SoundPlay, alert.mp3
			MsgBox, Found it
	} catch e {
		MsgBox, No Item
	}
}	

return

; add or remove item
^l::
; create file if it doesn't exist
if FileExist("searches.txt")
	FileAppend, , searches.txt

; #SingleInstance
SetTimer, ChangeButtonNames, 50 
MsgBox, 4, Add or Delete, Add or Delete a search item?
IfMsgBox, YES
    option := "add"
else 
    option := "delete"

if (option = "add"){
	InputBox, searchName, Enter a name for this search, Ex: mind of the council w/ arc dmg, , , 130
	InputBox, searchURL, Paste search URL, Example of a search URL: https://www.pathofexile.com/trade/search/Delve/lYWW6uV, , , 150
	FileAppend, %searchName%`n, searches.txt
	FileAppend, %searchURL%`n, searches.txt
	MsgBox, Name: %searchName%`nURL: %searchURL%	
} else {
	MsgBox, Can't delete yet ...
}
	
return

; overwrite button names
ChangeButtonNames: 
IfWinNotExist, Add or Delete
    return  ; Keep waiting.
SetTimer, ChangeButtonNames, Off 
WinActivate 
ControlSetText, Button1, &Add 
ControlSetText, Button2, &Delete 
return

; kill script
^+l::
ExitApp
