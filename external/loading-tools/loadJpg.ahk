#Requires AutoHotkey v2.0
;jpg loading 
;bokkbokk made this


resize := true ;;;Resize to 512x512
deleteAfter := false ;;;Remove temp file after loading, this will cause issues when using r to reset. 
;;keeping it isnt really an issue, it will be overwritten anyhow next time you load an image
;; and it will be removed when you close the script
TempPath := A_WinDir . "\temp\temp_image.png" ;;dont change this probly

color := "black" 
alpha := "1" ;  ;;not sure if this actually works

PadColor := color . "@" . alpha


^!l:: {
    SelectedFile := FileSelect(,, "Select an image to load", "Image Files (*.png; *.jpg; *.jpeg; *.bmp; *.gif; *.webp)")
    

    Cmd := 'ffmpeg -y -i "' SelectedFile '" "' TempPath '"'  ;;;regular command no resize

    if (!SelectedFile){
        return ;;dont do anything if no file
    }

    if (resize){
        Cmd := 'ffmpeg -y -i "' SelectedFile '" -vf "scale=w=512:h=512:force_original_aspect_ratio=decrease,pad=512:512:(ow-iw)/2:(oh-ih)/2:color=' PadColor '" "' TempPath '"' ;;resize to 512
    }
    
    RunWait A_ComSpec ' /c ' Cmd, , "Hide" ;;;do the ffmpeg
    
    try {
        WinActivate(windowName)
    } catch Error as e {
        MsgBox "PHOSIMP window not found. Please open PHOSIMP first." ;;or remove this trycatch if its not working even when phosimp is open
        return
    }

    SendInput("l")
    Sleep(100)
    SendInput("{Enter}")
    Sleep(100)
    SendInput(TempPath)
    Sleep(100)
    SendInput("{Enter}")
    Sleep(4000)
    if (deleteAfter){     
        FileDelete(TempPath) ;remove the converted temp file
    }
    return
}


OnExit JpgExit
JpgExit(*) {
    if (FileExist(TempPath)) {
        FileDelete(TempPath) ;remove the converted temp file
    }
}