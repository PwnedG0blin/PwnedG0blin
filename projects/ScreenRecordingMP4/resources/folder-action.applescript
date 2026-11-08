on adding folder items to this_folder after receiving added_items
    repeat with an_item in added_items
        try
            set filePath to POSIX path of an_item
            if filePath ends with ".mov" or filePath ends with ".MOV" then
                set scriptPath to (POSIX path of (path to home folder)) & "Library/Application Support/ScreenRecordingMP4/convert-folder-action.sh"
                do shell script "nohup /bin/bash " & quoted form of scriptPath & " " & quoted form of filePath & " >/dev/null 2>&1 </dev/null &"
            end if
        end try
    end repeat
end adding folder items to
