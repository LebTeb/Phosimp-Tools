#Requires AutoHotkey v2.0

outputDir := A_ScriptDir . "\segOut\segmented\"   
outFrames := A_ScriptDir . "\segOut\reciped\" ; Directory 
outFinal := A_ScriptDir . "\segOut\final.png"
outFinalDir := A_ScriptDir . "\segOut\"

tileSize := 512         



splitImage(recipe) {
    imagePath := FileSelect(,,"Choose Image")
    global size := GetImageSize(imagePath)
    SetWorkingDir(A_ScriptDir)

    FileDelete(outputDir . "*.*")
    FileDelete(outFrames . "*.*")
    FileDelete(outFinal . "*.*")

    cleanOutput := RTrim(outputDir, "\")  ; remove trailing backslas
    cmd := Format('segment.exe split "{1}" "{2}" {3}', imagePath, cleanOutput, tileSize)
    RunWait cmd
    ;;; ok splitting image is done now
    applyToEachSegment(recipe)
    Sleep(1000)
    reAssemble()
    

    Run "explorer.exe " outFinalDir

    SoundPlay A_ScriptDir . "\external\video\ding.mp3"


}
applyToEachSegment(recipe) {
    try {
        WinActivate(windowName)
    } catch Error as e {
        MsgBox "PHOSIMP window not found. Please open PHOSIMP first."
        return
    }
    Loop Files outputDir . "*.png" {
        ;MsgBox A_LoopFileFullPath
        SendInput("l")
        SendInput("{Enter}")
        Sleep(1000)
        SendInput(A_LoopFileFullPath)
        SendInput("{Enter}")
        Sleep(1000)
        applyRecipe(recipe) ; main applying from the main script 
        Sleep (100)                                                                ;signifigant delay to allow for the file explorer to not freak out
        SendInput("s")
        Sleep(500)
        SendInput("{Enter}")    
        Sleep(1000)
        SendInput(outFrames . A_LoopFileName . "")
        SendInput("{Enter}")
        Sleep (1000)
        if (breakIt = true) {
            MsgBox("Stopping and saving...")
            break
        }
    }
}

reAssemble() {
    Loop Files outFrames . "*.PNG" {
        newName := RegExReplace(A_LoopFileFullPath, "\.PNG$", ".png")
        FileMove(A_LoopFileFullPath, newName, 1)
    }
    ;;; id k whats going on here !!!!!!!!!!!
    cleanOutput := RTrim(outFrames, "\")
    cmd2 := Format('segment.exe reassemble "{1}" "{2}" {3} {4} {5}', outFinal, cleanOutput, size.w, size.h, tileSize)
    RunWait Format('"{1}" /c "{2}"', A_ComSpec, cmd2)


}

GetImageSize(filePath) {
    cmd := Format('ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "{1}"', filePath)
    shell := ComObject("WScript.Shell")
    exec := shell.Exec(cmd)
    result := exec.StdOut.ReadAll()
    parts := StrSplit(Trim(result), ",")
    return {w: parts[1], h: parts[2]}
}

