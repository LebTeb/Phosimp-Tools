#Requires AutoHotkey v2.0


CheckForUpdate() {
    temppath := A_WinDir . "\temp\checkVersion.txt"

    Download "https://bokkbokk.github.io/scripts/recipever.txt", temppath

    checkedVersionStr := Trim(FileRead(temppath), "`r`n ")
    checkedVersion := checkedVersionStr + 0

    if checkedVersion < version {
        MsgBox("What the hey! Did you change the version number >:(")
    }
    if checkedVersion > version {
        MsgBox("New version available!")

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
