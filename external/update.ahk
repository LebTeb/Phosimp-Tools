#Requires AutoHotkey v2.0


CheckForUpdate() {
    temppath := A_WinDir . "\Temp\scriptConfig.ini"

    Download "https://raw.githubusercontent.com/LebTeb/Phosimp-Tools/refs/heads/main/scriptConfig.ini", temppath

    checkedVersion := IniRead(temppath, "scriptConf", "scriptVersion")

    if checkedVersion < version {
        MsgBox("What the hey! Did you change the version number >:(")
    }
    if checkedVersion > version {
        Result := MsgBox("New version available! Would you like to download it?",, "YesNo")
        if Result = "Yes"
            Run "https://github.com/LebTeb/Phosimp-Tools/archive/refs/heads/main.zip"

    }
    if checkedVersion = version {
        MsgBox("Up to Date")
    }

    FileDelete(temppath) ;;;delete the temp file
}



; runs on launch
try {
    version := IniRead("scriptConfig.ini", "scriptConf", "scriptVersion")
    ;version := versionStr + 0 
} catch Error as e {
    MsgBox("Running dev version")
}
