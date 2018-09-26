; main search loop

searchURLS := []
searchNames := []

; create file if it doesn't exist
if !FileExist("searches.txt") 
{
	FileAppend, , searches.txt
} 
else 
{
	Loop, read, searches.txt 
	{
		if InStr(A_LoopReadLine, "www.pathofexile.com")
		{
			searchURLS.Push(A_LoopReadLine)
		}
		else
		{
			searchNames.Push(A_LoopReadLine)
		}
	}
}

; get file size for later
FileGetSize, searchSize, searches.txt
	
tick := 1
limit := 0
Loop 
{
	; get file size to check for changes
	FileGetSize, newSearchSize, searches.txt
	
	; skip iteration if no search items
	if (newSearchSize = 0) 
	{
		searchSize := newSearchSize
		tick := 1
		Continue
	}
		
	; reload search items if there was a change
	if (newSearchSize != searchSize) 
	{
		Loop, read, searches.txt 
		{
			if InStr(A_LoopReadLine, "www.pathofexile.com")
			{
				searchURLS.Push(A_LoopReadLine)
			}
			else
			{
				searchNames.Push(A_LoopReadLine)
			}
		}
		tick := 1
	}
	
	; get length of current array and set limit
	
	for index, element in searchURLS
	{
		limit++
	}
	
	if (tick > limit)
	{
		tick := 1
	}
	
	wb := ComObjCreate("InternetExplorer.Application") ; create a IE instance
	wb.Visible := False
	searchURL := searchURLS[tick]
	resultName := searchNames[tick]
	wb.Navigate(searchURL) ; this doesn't exist
	
	While wb.readyState != 4 || wb.document.readyState != "complete" || wb.busy || A_Index < 300 ; wait for the page to load
	Sleep, 10
	
	try
	{
		if wb.Document.GetElementsByClassName("itemBoxContent")[0].innertext
		{
			; SoundPlay, alert.mp3
			MsgBox, Found`n%searchURL%
			result := wb.Document.GetElementsByClassName("itemBoxContent")[0].innertext
			
			SetTimer, ChangeButtonNamesB, 50 
			MsgBox, 4, OK or Delete, %resultName%`nHas Been Found!

			IfMsgBox, YES
				option := "OK"
			else 
				option := "Delete"

			if (option = "OK"){
				MsgBox, I will continue to search for:`n%resultName%
			} else {
				; remove current search item from arrays
				searchURLS.Delete(searchURL)
				searchNames.Delete(resultName)
				
				; update searches.txt
				FileDelete, searches.txt
				FileAppend, , searches.txt
				
				tock := 1
				for index, element in searchNames
				{
					FileAppend, resultName, searches.txt
					FileAppend, search, searches.txt
					tock++
				}
				tick := 1
				Continue
			}
		}
	} 
	catch e 
	{
		MsgBox, No Item
	}
	
	tick++
}


; add or remove item
^l::
; #SingleInstance
SetTimer, ChangeButtonNamesA, 50 
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
ChangeButtonNamesA: 
IfWinNotExist, Add or Delete
    return  ; Keep waiting.
	
SetTimer, ChangeButtonNamesA, Off 
WinActivate 
ControlSetText, Button1, &Add 
ControlSetText, Button2, &Delete 
return

ChangeButtonNamesB: 
IfWinNotExist, OK or Delete
    return  ; Keep waiting.
	
SetTimer, ChangeButtonNamesB, Off 
WinActivate 
ControlSetText, Button1, &OK
ControlSetText, Button2, &Delete 
return

; kill script
^+l::
ExitApp