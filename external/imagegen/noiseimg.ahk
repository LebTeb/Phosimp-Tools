#Requires AutoHotkey v2.0



loadNoise() {
    PhotoUrl := "https://php-noise.com/noise.php?r=${r}&g=${g}&b=${b}&tiles=${tiles}&tileSize=${tileSize}&borderWidth=${borderWidth}&mode=${mode}&json"
    NoisePath := A_WorkingDir . "\noise.jpg"
    Download PhotoUrl, NoisePath
    ;;;the next lines will get the full path of the noise image and then save it as a variable
    SendInput("l")
    SendInput("{Enter}")
    Sleep(1000)                                                                               ;;;;ALL THE SLEEPS
    SendInput(NoisePath)
    Sleep(300)                                                                              ;;;;TWEAK THIS IF NEEDED                                               
    SendInput("{Enter}")
}