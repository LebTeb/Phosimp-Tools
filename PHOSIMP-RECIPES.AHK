;bokkbokk made this :)))
;Control Alt T to apply selected recipe
;contact me on discord with questions or suggestions or anything at all
#Requires AutoHotkey v2.0

#include external\loading-tools\loadJpg.ahk
#include external\video\PHOVID.ahk
#Include external\update.ahk
#Include config.ahk
#Include external\segment\segmentpic.ahk

windowName := "[ AVAILABLE ON STEAM : @KanjiCoder's : PHO-SIMP ]"

slow_filters := [17,18,19] ;; make into seperate file?

; get updated filter list
;Download "", 

recipeDir := A_ScriptDir "\recipes\"
if (recipe_dir_override) {
    recipeDir := recipe_dir_override           ;;;;; use override if set
}

PhosimpDir := GetPhosimpPath()
if (PhosimpDir = "") {
    PhosimpDir := DirSelect(,,"Select PHOSIMP installation folder")
}
if (PhosimpDir = "") {
    MsgBox "PHOSIMP directory not selected or found."
}

; get recipes from the folder
recipes := Array()
Loop Files, recipeDir "\*.txt", "R"  ; Recurse into subfolders (will break if they are in subfolders, but hoping to add that eventually)
{
    recipes.push(A_LoopFileName)
}


MyGui := Gui()
Tabs := MyGui.Add("Tab3",, ["Select", "Add","Video","Record","Extras","Info"])

Tabs.UseTab("Select")                                                                   ;;SELECT TAB
{
MyGui.AddText(,"PHOSIMP RECIPES!")
ddl := MyGui.Add("DropDownList", "w200", recipes)
refreshBtn := MyGui.Add("Button", "Default w80", "Refresh")

refreshBtn.OnEvent("Click", refreshBtn_Click)
refreshBtn_Click(*) {
    refreshRecipes()
}

SelectedContent := MyGui.Add("Edit", "w300 h200 Multi WantReturn")
selectedRecipe := ""
ddl.OnEvent("Change", DDL_Change)
    ;MyGui.Add("Button", , "Show Selected").OnEvent("Click", ShowSelected)


DDL_Change(*) {
    global selectedRecipe, ddl
    selectedRecipe := ddl.Text
    SelectedContent.Text := FileRead(recipeDir . selectedRecipe)

    ;;;for video tab;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    recipeSelected.Text := "Selected Recipe: " . selectedRecipe
    ;;;for video tab;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

}


SaveBtn := MyGui.Add("Button", "Default w80", "Save")
SaveBtn.OnEvent("Click", SaveSelected)
SaveSelected(*) {
    if (selectedRecipe = "") {
        MsgBox "No recipe selected!"
        return
    }
    if (SelectedContent.Text = "") {
        MsgBox "empty!"
        return
    }
    outFile := recipeDir . selectedRecipe
    FileDelete(outFile) ;
    FileAppend(SelectedContent.Text, outFile)
    MsgBox "Recipe '" selectedRecipe "' saved!"
    refreshRecipes()
}
MyGui.AddText(,"Press Control Alt T to apply the recipe")
MyGui.AddText(,"!!Warning: this types into whatever window you have selected!!")
}


Tabs.UseTab("Record")                                                                   ;;INFO TAB
{
MyGui.AddText(,"TODO/TOFIX")



; MyBtn := MyGui.Add("Button", "Default w80", "Start Recording recipe")
; MyBtn.OnEvent("Click", RunToSaveRec)
; MyGui.AddText(, "Recipe Name:")
; recipeNameEdit := MyGui.Add("Edit", "w200 vRecipeName")

; MyGui.AddText(,"THIS DONT WORK :'( and i cant figure out why")




 StartRegBtn := MyGui.Add("Button", "Default w80", "Start PHOSIMP (no recording)")
 StartRegBtn.OnEvent("Click", LaunchPHOSIMPnoRec)
}


Tabs.UseTab("Add")                                                                      ;;ADD TAB
{
MyGui.AddText(,"Add a new recipe to the list")
MyGui.Add("Text",, "Name of recipe:")
recipeNameSave := MyGui.Add("Edit", "w200")
recipeContentEdit := MyGui.Add("Edit", "r9 vRecipeContent w135")
MyGui.Add("Button", "Default w80", "Add Recipe").OnEvent("Click", AddRecipe)
AddRecipe(*) {
    recipeName := recipeNameSave.Text
    recipeContent := recipeContentEdit.Text
    if (recipeName = "") {
        MsgBox "no name!"
        return
    }
    if (recipeContent = "") {
        MsgBox "empty!"
        return
    }

    outFile := recipeDir . recipeName . ".txt"
    FileAppend(recipeContent, outFile)
    MsgBox "Recipe '" recipeName "' added!"
    recipeNameSave.Text := "" 
    recipeContentEdit.Text := ""  
}
}


Tabs.UseTab("Info")                                                                     ;;INFO TAB
{
MyGui.AddText(,"PHOSIMP - KANJICODER")
MyGui.Add("Link",, 'PHOSIMP on <a href="https://store.steampowered.com/app/3721650/PHOSIMP/">Steam</a>, <a href="https://tinyurl.com/PHOSIMP">Discord</a>')
MyGui.Add("Link",, 'Original script made by <a href="https://github.com/bokkbokk">bokkbokk</a>, continued by <a href="https://github.com/LebTeb">Leb</a> :3')
MyGui.AddText("w300 +Wrap","Hotkeys:")
MyGui.AddText("w300 +Wrap","Control + Alt + T: Apply selected recipe")
MyGui.AddText("w300 +Wrap","Control + Alt + R: Randomly select a recipe and apply it (hold down?)")
MyGui.AddText("w300 +Wrap", "Control + Alt + S: Stop random spam (from extras tab, doesn't really work? mostly because the filters are being applied so fast that it kinda backlogs)")
MyGui.AddText("w300 +Wrap","Control + Alt + P: Load a random image from picsum.photos")
MyGui.AddText("w300 +Wrap","Control + Alt + L: Load any image, not just png, also resizes it to 512x512")

MyGui.AddButton("Default w80", "Check for Updates").OnEvent("Click", doCheck)
doCheck(*) {
    try {
        CheckForUpdate()
    } catch Error as e {
        MsgBox "Error checking for updates: " e.Message
    }
}
;MyGui.UseTab() ; End tab section
}


Tabs.UseTab("Extras")
{
AllBtn := MyGui.AddButton("Default w80", "Run Every Filter in order")
AllBtn.OnEvent("Click", RunAllFilters)
RunAllFilters(*) {
    try {
        WinActivate(windowName)
    } catch Error as e {
        MsgBox "PHOSIMP window not found. Please open PHOSIMP first."
        return
    }
    Loop 604 {
        SendInput(A_Index)
        SendInput("{Enter}")
        
    }

}

CrashBtn := MyGui.AddButton("Default w80", "Crash Finder?") ;;;; crashfinder (LOAD WITH A PURE WHITE IMG OR PURE BLACK)
CrashBtn.OnEvent("Click", CrashFinder1)
CrashFinder1(*) {
    try {
        WinActivate(windowName)
    } catch Error as e {
        MsgBox "PHOSIMP window not found. Please open PHOSIMP first."
        return
    }
    Loop 604 {
        SendInput(A_Index)
        SendInput("{Enter}")
        SendInput(A_Index)
        SendInput("{Enter}")
        SendInput(A_Index)
        SendInput("{Enter}")
        SendInput("r")
        SendInput("{Enter}")
    }
}

dontStopMakeItPopDJBlowMySpeakersUpTonightImaFightTillWeSeeTheSunLight := true

CrashBtn2 := MyGui.AddButton("Default w80", "Crash Finder2 (Random Spam)") ;;;crashfinder inverted in the beginning 
CrashBtn2.OnEvent("Click", CrashFinder2)
CrashFinder2(*) {
    global dontStopMakeItPopDJBlowMySpeakersUpTonightImaFightTillWeSeeTheSunLight
    try {
        WinActivate(windowName)
    } catch Error as e {
        MsgBox "PHOSIMP window not found. Please open PHOSIMP first."
        return
    }
    
    while dontStopMakeItPopDJBlowMySpeakersUpTonightImaFightTillWeSeeTheSunLight {
        randNum := Random(1, 604)
        SendInput(randNum)
        SendInput("{Enter}")
        Sleep(10)
    }

}
^!s:: {
    global dontStopMakeItPopDJBlowMySpeakersUpTonightImaFightTillWeSeeTheSunLight
    dontStopMakeItPopDJBlowMySpeakersUpTonightImaFightTillWeSeeTheSunLight := false
    MsgBox "Stopped random spam."
}

CapLogBtn := MyGui.AddButton("Default w80", "Launch Capture Logs")     
CapLogBtn.OnEvent("Click", LaunchCaptureLogs)
LaunchCaptureLogs(*) {
    logPath := A_ScriptDir "\output.txt"
    FileAppend("", logPath) ; ensure it exists/cleared first

    Run A_ComSpec ' /c "cd /d "' PhosimpDir '" && "KANJI_CODER.PHO_SIMP.EXE" > "' logPath '" "', , "Hide"
    ;SetTimer ReadLog, 1000
}

MyGui.AddText(,"All these should focus phosimp if its open")
MyGui.AddText(,"See info tab for all hotkeys")
}


Tabs.UseTab("Video")                                                                   ;;VIDEO TAB
{
MyGui.AddText(,"Video Processing")

VideoStateLabel := MyGui.AddText("w200","IDLE")

recipeSelected := MyGui.Add("Text", "w200", "Selected Recipe: None")

OutputDDL := MyGui.Add("DropDownList", "w200", ["mp4", "gif","webm","avi"])       ;;;;;;ddl for formats 
selectedOutputFormat := "mp4"
OutputDDL.OnEvent("Change", OutputDDL_Change)
OutputDDL_Change(*) {
    global selectedOutputFormat
    selectedOutputFormat := OutputDDL.Text
}

StartVidBtn := MyGui.Add("Button", "Default w80", "Start Video Processing")
StartVidBtn.OnEvent("Click", runVideoScript)




MyGui.AddText("w200 +Wrap","Clicking anywhere will break it, and itl start typing things into the window, bad idea")
MyGui.AddText("w200 +Wrap","Blur filters or any filter that takes a considerable amount of time will likely break the script")
MyGui.AddText("w200 +Wrap","If you need to use these, adjust the delays in the script accordingly")

MyGui.AddText("+Wrap","Press Ctrl Alt B to stop the video early and save it as a video")
}

MyGui.OnEvent("Close", GuiClose)
MyGui.Show()
        

             
     
   
 
    
                                                                                        ;;LOVELY FUNCTIONS 

GuiClose(*) {
    try {
        ;;ProcessClose("KANJI_CODER.PHO_SIMP.EXE")
    } catch {

    }
    ExitApp
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START OF RECORDING STUFF
{
; RunToSaveRec(*) {
;     global savingName, recipeNameEdit
;     savingName := recipeNameEdit.Text
;     ;;;steal logs from phosimp into output file
;     SetWorkingDir PhosimpDir ;;steam phosimp directory
;     FileAppend("", "output.txt")
;     Run A_ComSpec ' /c ""KANJI_CODER.PHO_SIMP.EXE" > "output.txt""', , 'Hide'
;     SetTimer ReadLog, 1000
;     SetWorkingDir(A_ScriptDir)
; }


; AppendNewRecipeStepsToFile() {
;     global savingName, recipeNameEdit, recipeDir
;     static lastLineNum := 0
;     savingName := recipeNameEdit.Text
    
;     outFile := recipeDir . savingName . ".txt"
;     lines := StrSplit(FileRead("output.txt"), "`n", "`r")
;     for i, line in lines {
;         if (i > lastLineNum) {
;             if InStr(line, "recipe_step_afi")
;                 FileAppend(line "`n", outFile) ;;;;;doesnt work, why???????????? sometimes outputs, sometime doesnt,??????
;         }
;     }
;     lastLineNum := lines.Length
; }


; ReadLog() {
;     AppendNewRecipeStepsToFile() ;this for now
; }

LaunchPHOSIMPnoRec(*) {
    Run "KANJI_CODER.PHO_SIMP.EXE", PhosimpDir

}
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF RECORDING STUFF


GetPhosimpPath() {
    readeded := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam", "InstallPath", "")
    if RegRead = "" {
        MsgBox "Steam not found."
        return
    }

    steamPath := readeded
    commonPath := steamPath "\steamapps\common\PHOSIMP"
    if FileExist(commonPath "\KANJI_CODER.PHO_SIMP.EXE") {
        return commonPath
    }

    MsgBox "PHOSIMP not found in default Steam directory."
    return ""
}

refreshRecipes(*) {
    global ddl 
    ddl.Delete()  
    recipes := []  
    Loop Files, recipeDir "\*.txt", "R" {
        recipes.Push(A_LoopFileName)
    }
    ddl.Add(recipes)  
}
     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;VIDEO SCRIPT ENTRY

runVideoScript(*) {
    if (selectedRecipe = "") {
        MsgBox "No recipe selected!"
        return
    }

    try {
        WinActivate(windowName)
    } catch Error as e {
        MsgBox "PHOSIMP window not found. Please open PHOSIMP first."
        return
    }
    MainVideoFuntion(selectedRecipe, selectedOutputFormat)
}





                 
;;;
;;; HOTKEYS
;;;


^!t:: {
    applyRecipe(selectedRecipe)
}





applyRecipe(recipe) {
    SendInput("{Ctrl up}{Alt up}{Shift up}")
    try {
        WinActivate(windowName)
    } catch Error as e {
        MsgBox "PHOSIMP window not found. Please open PHOSIMP first."
        return
    }
    onlynum := "\d+"
    try {
        Loop Read recipeDir . recipe {                                               ;;MAIN APPLY HOTKEY
            if RegExMatch(A_LoopReadLine, onlynum, &m) {
                SendInput(m[])       ; numbers found         NOTE FOR ME TOMMOROW: RUN THROUGH PHOSIMP TO FIND ALL FILTERS THAT HAVE A IMPACTFUL DELAY, THEN USE THAT TO ADD MORE DELAY IN VIDEO MAKING SCRIPT, AND ALSO FIGURE OUT HOW TO DO THAT ONLY FOR VIDEO SCRIPT SINCE NOW BOTH USE THE SAME FUNCTION? PERHAPS A SHITTY IF STATEMENT AND A VARIABLE, MAYBE ACTUALLY THERES A A_ VARIABLE FOR THAT
                SendInput("{Enter}")
                if (m[] == 17) {
                    Sleep 1000
                }
                Sleep 10
            }
        }
    } catch Error as e {
        MsgBox("No Recipe Selected")
    }
    SendInput("{Ctrl up}{Alt up}{Shift up}")
}

^!r:: {
    randNum := Random(1, 420)
    SendInput(randNum)
    SendInput("{Enter}")
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;LOAD RANDOM IMAGE AHK 

JpgPath := A_WinDir . "\temp\temp_jpg.jpg"
PngPath := A_WinDir . "\temp\temp_png.png" 
PhotoUrl := "https://picsum.photos/512" 

^!p:: {
    
    if GetKeyState("Ralt", "P") {
        PhotoUrl := "https://picsum.photos/512?grayscale"
    } else {
        PhotoUrl := "https://picsum.photos/512"
    }

    try {
        Download PhotoUrl, JpgPath
    } catch {
        MsgBox "Failed to download image, are you connected to the internet?"
        return
    }
    Sleep(10)  ; wait for a second before proceeding     
    Cmd := 'ffmpeg -y -i "' JpgPath '" "' PngPath '"' ;no need for resize                                       ;;;;;;;;;;TWEAK THIS IF NEEDED
    RunWait A_ComSpec ' /c ' Cmd, , "Hide" ;;;do the ffmpeg
    Sleep(50)   ; wait for ffmpeg to finish processing                                           ;;;;;;;;;;THIS TOO
    FileDelete(JpgPath) ; remove the temp file
    try {
        WinActivate(windowName)
    } catch Error as e {
        MsgBox "PHOSIMP window not found. Please open PHOSIMP first."
        return
    }
    SendInput("l")
    SendInput("{Enter}")
    Sleep(1000)                                                                               ;;;;ALL THE SLEEPS
    SendInput(PngPath)
    Sleep(900)                                                                              ;;;;TWEAK THIS IF NEEDED                                               
    SendInput("{Enter}")

}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;LOAD RANDOM IMAGE AHK 




#Include external\imagegen\noiseimg.ahk
^!n:: {
    loadNoise
}

^!q:: {
    throughGui := Gui()
    throughGui.AddText(,"Select Starting and Ending Number")
    throughGui.AddText(,"Starting Number:")
    startNumEdit := throughGui.Add("Edit", "w200 Number")
    throughGui.AddText(,"Ending Number:")
    endNumEdit := throughGui.Add("Edit", "w200 Number")
    throughGui.AddButton("Default w80", "RunRange").OnEvent("Click", RunRange)
    throughGui.Show()

    RunRange(*){
        
        ;;;msgbox every number in the range
        ;; use loop?
        startNum := startNumEdit.Text
        endNum := endNumEdit.Text
        if (startNum = "" || endNum = "") {
            MsgBox "Please enter both starting and ending numbers."
            return
        }
        if (startNum > endNum) {
            MsgBox "Starting number must be less than or equal to ending number."
            return
        }
        try {
            WinActivate(windowName)
        } catch Error as e {
            MsgBox "PHOSIMP window not found. Please open PHOSIMP first."
            return
        }
        ;;;ahk 2.0 loop to msgbox every number in the range
        ; Loop through the range

        current := startNum
        Loop {
            SendInput(current)
            SendInput("{Enter}")
            if (current >= endNum)
                break
            current++
        }
        throughGui.Destroy()
    
        
    }
}

^!W:: {
    splitImage(selectedRecipe)
}















OnExit ExitMain
ExitMain(*) {
    if (FileExist(JpgPath)) {
        FileDelete(JpgPath) ; remove the temp file
    }
    if (FileExist(PngPath)) {
        FileDelete(PngPath) ; remove the temp file
    }
}

ExitScript() {
    Exit
}


; Owner: Use +Owner to make the window owned by another. An owned window has no taskbar button by default, and when visible it is always on top of its owner. It is also automatically destroyed when its owner is destroyed, as long as the owner was created by the same script (i.e. has the same process ID). +Owner can be used before or after the owned window is created. There are two ways to use +Owner, as shown below:

; MyGui.Opt("+Owner" OtherGui.Hwnd)  ; Make the GUI owned by OtherGui.
; MyGui.Opt("+Owner")  ; Make the GUI owned by the script's main window to prevent display of a taskbar button.