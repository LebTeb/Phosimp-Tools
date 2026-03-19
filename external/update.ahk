#Requires AutoHotkey v2.0


CheckForUpdate() {
    temppath := A_WinDir . "\temp\checkVersion.txt"

    Download "https://raw.githubusercontent.com/LebTeb/Phosimp-Tools/refs/heads/main/external/versionnum.txt", temppath

    checkedVersionStr := Trim(FileRead(temppath), "`r`n ")
    checkedVersion := checkedVersionStr + 0

    if checkedVersion < version {
        MsgBox("What the hey! Did you change the version number >:(")
    }
    if checkedVersion > version {
        ;MsgBox("New version available!")
        Result := MsgBox("New version available! Would you like to download it?",, "YesNo")
        if Result = "Yes"
            Run "https://github.com/LebTeb/Phosimp-Tools/archive/refs/heads/main.zip"

    }
    if checkedVersion = version {
        MsgBox("Up to Date")
    }

    FileDelete(temppath) ;;;delete the temp file
}




try {
   versionStr := Trim(FileRead("external\versionnum.txt"), "`r`n ")
    version := versionStr + 0 
} catch Error as e {
    MsgBox("Running dev version")
}
