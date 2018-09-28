; main search loop
^!j::

MsgBox, Can Do!

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
		
		if InStr(A_LoopReadLine, "https:`/`/www.pathofexile.com`/trade`/search`/")
		{
			searchURLS.Push(A_LoopReadLine)
		}
		else if InStr(A_LoopReadLine, "http:`/`/poe.trade`/search`/")
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

; create IE commObject and hide it
wb := ComObjCreate("InternetExplorer.Application") ; create a IE instance
wb.Visible := False

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
		searchSize := newSearchSize
		
		; clear arrays
		searchURLS := []
		searchNames := []
		
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
	limit := 0
	for index, element in searchURLS
	{
		limit++
	}
	
	if (tick > limit)
	{
		tick := 1
	}
	
	searchURL := searchURLS[tick]
	resultName := searchNames[tick]
	wb.Navigate(searchURL) ; this doesn't exist
	
	While wb.readyState != 4 || wb.document.readyState != "complete" || wb.busy || A_Index < 300 ; wait for the page to load
	Sleep, 10
	
	try
	{
		if wb.Document.GetElementsByClassName("itemBoxContent")[0].innertext
		{
			result := wb.Document.GetElementsByClassName("itemBoxContent")[0].innertext
			
			Gui, ItemFound: new 
			; Gui, ItemFound:Add, text, +Center vFoundHeader, Found
			Gui, ItemFound:Add, text, +Center vFoundName, %resultName%
			Gui, ItemFound:Add, Link,, View Item <a href="%searchURL%">link</a>
			; Gui, ItemFound:Add, Link,, View <a href=%searchURL%>Here</a>
			Gui ItemFound:Add, button, x0 y50 w75 h30 gHide, Hide
			Gui ItemFound:Add, button, x125 y50 w75 h30 gRemove, Delete
			xLocation := A_ScreenWidth-200
			Gui ItemFound: Show, x%xLocation% y0 NA w200 h80, Found One!
			
			; SoundPlay, alert.mp3
			SoundBeep, 200, 700
			
			pausing := 1
			
			Loop
				z := z
			Until pausing = 0
		}
	} 
	catch e 
	{}
	
	tick++
}


; add or remove item
^j::
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
	if (searchSize > 0)
	{
		FileAppend, `n, searches.txt
	}
	FileAppend, %searchName%`n, searches.txt
	FileAppend, %searchURL%`n, searches.txt
	MsgBox, Name: %searchName%`nURL: %searchURL%	
} else {
	; MsgBox, Can't delete yet ...	
	
	;find new longest name so we can scale the GUI width
	longest := 0
	temp := ""
	
	;create the GUI so we can add rows in the loop too
	Gui, SearchList: new
	Gui, SearchList:Add, ListView, x0 y0 w300 h270 +Center grid checked, Name
	
	for index, element in searchNames
	{
		currentLength := StrLen(searchNames[index])
		temp2 := searchNames[index]
		
		;add rows to Gui
		lv_add("-check", searchNames[index], searchURLS[index])
	
		if (currentLength > longest)
		{
			longest := currentLength
			temp := searchNames[index]
		}
	}	

	lv_modifycol(1, "AutoHdr")
	lv_modifycol(2, "AutoHdr")
	Gui SearchList:Add, button, x90 y275 gDelete, Delete
	Gui SearchList:Add, button, x160 y275 gBrowse, View
	Gui SearchList:Show, h305 w300, Delete Search Items
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

Hide:
	Gui ItemFound:Destroy
	pausing := 0
return

Remove:
	Gui ItemFound:Destroy
	pausing := 0
	; remove current search item from arrays
	searchURLS.RemoveAt(tick)
	searchNames.RemoveAt(tick)
				
	; update searches.txt
	FileDelete, searches.txt
				
	tock := 1
	for index, element in searchNames
	{
		loadName := element
		loadURL := searchURLS[index]
		FileAppend, %loadName%, searches.txt
		FileAppend, `n, searches.txt
		FileAppend, %loadURL%, searches.txt
					
		; append empty line if not the last entry
		if (tock < limit)
		{
			FileAppend, `n, searches.txt
		}
		tock++
	}
	tick := 1
return

Delete:
	checkedRowList :=
	checked :=
	while rowNumber := LV_GetNext(rowNumber, "C")
	{
		checkedRowList .= rowNumber . "X"
	}
	checked := RTrim(checkedRowList)
	checkedArray := StrSplit(checked, "X")
	Gui SearchList:Destroy
	
	; loop through checked array and delete corresponding items from searches.txt
	for index, element in checkedArray
	{
		if (element > 0)
		{
			; remove current search item from arrays
			searchURLS.RemoveAt(index)
			searchNames.RemoveAt(index)
			
			; update searches.txt
			FileDelete, searches.txt
				
			tock := 1
			for index, element in searchNames
			{
				loadName := element
				loadURL := searchURLS[index]
				FileAppend, %loadName%, searches.txt
				FileAppend, `n, searches.txt
				FileAppend, %loadURL%, searches.txt
				
				; append empty line if not the last entry
				if (tock < limit)
				{
					FileAppend, `n, searches.txt
				}
				tock++
			}
			tick := 1
		}
	}
return

Browse:
	checkedRowList :=
	checked :=
	while rowNumber := LV_GetNext(rowNumber, "C")
	{
		checkedRowList .= rowNumber . "X"
	}
	checked := RTrim(checkedRowList)
	checkedArray := StrSplit(checked, "X")
	Gui, Destroy
	
	; loop through checked array and delete corresponding items from searches.txt
	for index, element in checkedArray
	{
		if (element > 0)
		{
			; open selected search items in a browser
			
			target := searchURLS[index]
			Run, %target%
		}
	}
return

; kill script
^+j::
; destroy IE comobject
wb.quit
ExitApp