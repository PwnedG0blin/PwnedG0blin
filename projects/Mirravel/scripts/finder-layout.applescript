on run argv
    set volumeName to item 1 of argv
    set operation to item 2 of argv
    tell application "Finder"
        tell disk volumeName
            open
            if operation is "configure" then
                tell container window
                    set current view to icon view
                    set toolbar visible to false
                    set statusbar visible to false
                    set bounds to {180, 110, 720, 458}
                end tell
                set options to icon view options of container window
                set arrangement of options to not arranged
                set icon size of options to 64
                set text size of options to 12
                set background picture of options to file ".background:background.png"
                set position of item "Mirravel.app" of container window to {130, 210}
                set position of item "Applications" of container window to {410, 210}
                close
                open
                delay 1
                set bounds of container window to {180, 110, 710, 448}
                delay 1
                set bounds of container window to {180, 110, 720, 458}
                update without registering applications
                delay 3
            end if
            if current view of container window is not icon view then error "Finder ignored icon view."
            set options to icon view options of container window
            if icon size of options is not 64 then error "Finder ignored icon size."
            set pictureFile to background picture of options
            if name of pictureFile is not "background.png" then error "Finder ignored background."
            if position of item "Mirravel.app" of container window is not {130, 210} then error "App position mismatch."
            if position of item "Applications" of container window is not {410, 210} then error "Applications position mismatch."
            if statusbar visible of container window then error "Finder ignored status bar setting."
            set windowBounds to bounds of container window
            if (item 3 of windowBounds) - (item 1 of windowBounds) is not 540 then error "Window width mismatch."
            if (item 4 of windowBounds) - (item 2 of windowBounds) is not 348 then error "Window height mismatch."
            close
        end tell
    end tell
end run
