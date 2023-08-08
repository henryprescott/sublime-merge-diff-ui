MyGui := Gui()
MyGui.Title := "Sublime Diff"
SetWorkingDir "C:\"
MyGui.Title := "Sublime Merge"

; First row label, text field, browser button
MyGui.Add("Text", "w35 h30 x20 y15", "1st:")  ; Save this control's position and start a new section.
FirstFileEdit := MyGui.Add("Edit", "w350 x55 y11")
MyGui.Add("Button", "Default x415 w75 y10", "Browse...").OnEvent("Click", Set_First_File_Path)

; Second row label, text field, browser button
MyGui.Add("Text", "w35 x15 y50", "2nd:")
SecondFileEdit := MyGui.Add("Edit", "w350 x55 y45")
MyGui.Add("Button", "Default x415 w75 y45", "Browse...").OnEvent("Click", Set_Second_File_Path)

; OK & Cancel buttons
MyGui.Add("Button", "Default x331 y75 w75", "OK").OnEvent("Click", Launch_Sublime_Merge)
MyGui.Add("Button", "Default x415 y75 w75", "Cancel").OnEvent("Click", Call_Exit)

MyGui.OnEvent("DropFiles", File_Drop)

MyGui.Show

First_Clicked(*)
{
	DragTarget := FirstFileEdit
}

Second_Clicked(*)
{
	DragTarget := SecondFileEdit
}

Set_First_File_Path(*)
{
	File1 := FileSelect("3")  ; M3 = Multiselect existing files.
	if File1 != ""
	{
		FirstFileEdit.Value := File1

		; WinExist("A") ; Set the Last Found Window to the active window
		; ControlGet, hWndControl, Hwnd, , SecondFileEdit  ; Get HWND of first Button
		; SendMessage, 0x00B1, hWndControl, True  ; 0x0028 is WM_NEXTDLGCTL
	}
}

Set_Second_File_Path(*)
{
	File1 := FileSelect("3")  ; M3 = Multiselect existing files.
	if File1 != ""
	{
		SecondFileEdit.Value := File1

		; WinExist("A") ; Set the Last Found Window to the active window
		; ControlGet, hWndControl, Hwnd, , SecondFileEdit  ; Get HWND of first Button
		; SendMessage, 0x00B1, hWndControl, True  ; 0x0028 is WM_NEXTDLGCTL
	}
}

Calc_Distance(x1,x2,y1,y2)
{
	return Sqrt( (x2 - x1)**2 + (y2 - y1)**2 )
}

File_Drop(thisGui, Ctrl, FileArray, *)  ; Support drag & drop.
{
	MouseGetPos &mouseXPos, &mouseYPos

	FirstFileEdit.GetPos(&firstXPos, &firstYPos, &firstWidth, &firstHeight )

	FirstFileXCentre := firstXPos + (firstWidth/2)
	FirstFileYCentre := firstYPos + (firstHeight/2)

	MouseDistanceFromFirst := Calc_Distance(FirstFileXCentre, mouseXPos, FirstFileYCentre, mouseYPos)

	SecondFileEdit.GetPos(&secondXPos, &secondYPos, &secondWidth, &secondHeight )

	SecondFileXCentre := secondXPos + (secondWidth/2)
	SecondFileYCentre := secondYPos + (secondHeight/2)

	MouseDistanceFromSecond := Calc_Distance(SecondFileXCentre, mouseXPos, SecondFileYCentre, mouseYPos)

	if (MouseDistanceFromFirst < MouseDistanceFromSecond)
	{
		FirstFileEdit.Value := readContent(FileArray[1])  ; Read the first file only (in case there's more than one).
	}
	else
	{
		SecondFileEdit.Value := readContent(FileArray[1])  ; Read the first file only (in case there's more than one).
	}

    ; FirstFileEdit.Value := readContent(FileArray[1])  ; Read the first file only (in case there's more than one).

    ; FirstFileEdit.Value := ' ( ' FirstFileXCentre ' , ' FirstFileYCentre ' )  ( ' SecondFileXCentre ' , ' SecondFileYCentre ' ) ( ' mouseXPos ' , ' mouseYPos ' )'
    ; SecondFileEdit.Value := MouseDistanceFromFirst ' | ' MouseDistanceFromSecond
}

readContent(FileName)
{
    try
        FileContent := FileRead(FileName)  ; Read the file's contents into the variable.
    catch
    {
        MsgBox("Could not open '" FileName "'.")
        return
    }
    return FileName
}


Call_Exit(*) 
{
    Exit ; Terminate this function as well as the calling function.
}

Launch_Sublime_Merge(*)
{
	; SecondFileEdit.Value := 'sublime_merge.exe smerge mergetool ' FirstFileEdit.Value ' ' SecondFileEdit.Value
	Run 'smerge mergetool ' FirstFileEdit.Value ' ' SecondFileEdit.Value, , "Hide"
	;Run 'smerge mergetool C:\Users\Henry\Documents\Git\orbitology-URP\.gitignore C:\Users\Henry\Documents\Git\POC\.gitignore', , "Hide"
	ExitApp
}

