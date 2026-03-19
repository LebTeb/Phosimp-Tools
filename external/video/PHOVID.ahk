#Requires AutoHotkey v2.0
global breakIt := false ;;;Flag to break the video processing loop

MainVideoFuntion(recipe,outputFormat){
;bokkbokk make this :)
    recipePath := recipe

    ;input     := A_ScriptDir . "\input.mp4"                ;Input video file
    inFrames  := A_ScriptDir . "\external\video\inframes\"                ;Folder full of pngs that make up a video ideally 
    outFrames := A_ScriptDir . "\external\video\outframes\"               ;Empty folder for frames output
    out       := A_ScriptDir . "\external\video\outg\"                    ;Empty folder for output video
    outFile   :=     out     . "output." . outputFormat ;;;Output video file with the selected format

    videoState := "NOT GOING" ;;;Flag to check if video processing is running
    
    runVid
    
    runVid(*){
        VideoStateLabel.text := "PROCCESSING"
        input := FileSelect(,, "Select video", "Video Files (*.mp4; *.avi; *.mkv; *.mov; *.flv; *.wmv; *.gif)")
        cmd := Format(
            'ffmpeg -i "{1}" -vf "scale=512:512:force_original_aspect_ratio=decrease,pad=512:512:(ow-iw)/2:(oh-ih)/2" "{2}frame_%04d.png"',
            input, inFrames ;change back to inframes 
        )
        ;clear all files from the inframes, outframes, and outg folders
        FileDelete(inFrames . "*.*")
        FileDelete(outFrames . "*.*")
        FileDelete(out . "*.*")

        Sleep(1000) ;wait for deletion



        breakIt := false ;;;Reset the break flag
        VideoToFrames(cmd)
        ProccessVid
        FramesToVideo(input)
        VideoStateLabel.text := "DONE"
        Run "explorer.exe " out

        SoundPlay A_ScriptDir . "\external\video\ding.mp3"


        breakIt := false ;;;Reset the break flag

    }

    ProccessVid(*){
        Loop Files inFrames . "*.png" {
            ;MsgBox A_LoopFileFullPath
            SendInput("l")
            SendInput("{Enter}")
            Sleep(1000)
            SendInput(A_LoopFileFullPath)
            SendInput("{Enter}")
            Sleep(1000)
            applyRecipe(recipePath) ; main applying from the main script 
            Sleep (100)                                                                ;signifigant delay to allow for the file explorer to not freak out
            SendInput("s")
            Sleep(500)
            SendInput("{Enter}")    
            SendInput(outFrames . A_LoopFileName . "")
            SendInput("{Enter}")
            Sleep (1000)
            if (breakIt = true) {
                MsgBox("Stopping and saving...")
                break
            }
        }
    }

    VideoToFrames(cmd){
        RunWait(cmd, A_ScriptDir)
    }

    FramesToVideo(input){
        fps := GetFrameRate(input)
        cmd := Format(
            'ffmpeg -framerate {1} -i "{2}frame_%04d.png" -c:v libx264 -pix_fmt yuv420p "{3}"',
            fps, outFrames, outFile
        )

        if (outputFormat = "gif") {
            cmd := Format(
                'ffmpeg -framerate {1} -i "{2}frame_%04d.png" -vf "scale=512:512:force_original_aspect_ratio=decrease,pad=512:512:(ow-iw)/2:(oh-ih)/2" "{3}"',
                fps, outFrames, outFile
            )
        } else if (outputFormat = "webm") {
            cmd := Format(
                'ffmpeg -framerate {1} -i "{2}frame_%04d.png" -c:v libvpx-vp9 -pix_fmt yuv420p "{3}"',
                fps, outFrames, outFile
            )
        } else if (outputFormat = "avi") {
            cmd := Format(
                'ffmpeg -framerate {1} -i "{2}frame_%04d.png" -c:v libxvid "{3}"',
                fps, outFrames, outFile
            )
        }



        try {
            RunWait(cmd, A_ScriptDir)
        } catch Error as e {
            MsgBox e.Message
        }
    }

    GetFrameRate(inputFile) {
        cmd := Format('ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate "{1}"', inputFile)
        shell := ComObject("WScript.Shell")
        exec := shell.Exec(A_ComSpec . " /C " . cmd)
        rate := exec.StdOut.ReadAll()
        return Trim(rate)
    }

}
doTheBreak(*){
    global breakIt
    breakIt := true
}

^!b:: {
    doTheBreak()
    Sleep(100)
}