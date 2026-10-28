-- Copyright (c) 2026 PwnedG0blin · SPDX-License-Identifier: MIT
on run
  set menuPath to POSIX path of (path to resource "Mirravel.command")
  set guidePath to POSIX path of (path to resource "Anleitung.txt")
  set resultDialog to display dialog "Mirravel 0.2.2 Beta\nEntwickelt von PwnedG0blin\n\nExperimenteller Helfer für iPhone Mirroring: Diagnose, optionaler Mac-Patch und Rücknahme.\n\nDie App öffnet ein Terminal-Menü. Der Patch beginnt erst nach deiner Eingabe TEST und einer lokalen Administratorabfrage. Eine funktionierende Verbindung ist nicht garantiert." buttons {"Abbrechen", "Anleitung", "Terminal-Menü"} default button "Terminal-Menü" with title "Mirravel · Beta"
  if button returned of resultDialog is "Anleitung" then
    do shell script "/usr/bin/open -t " & quoted form of guidePath
  else
    do shell script "/usr/bin/open -a Terminal " & quoted form of menuPath
  end if
end run

