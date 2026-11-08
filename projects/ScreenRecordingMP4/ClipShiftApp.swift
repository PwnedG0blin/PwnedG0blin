import SwiftUI
import Foundation
import AppKit

@main
struct ClipShiftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 490, height: 390)
                .preferredColorScheme(.light)
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 490, height: 390)
    }
}

struct ContentView: View {
    @State private var message: String = ""
    @State private var busy = false
    private var german: Bool { Locale.preferredLanguages.first?.lowercased().hasPrefix("de") ?? false }

    var body: some View {
        ZStack {
            Color(red: 0.965, green: 0.973, blue: 0.99).ignoresSafeArea()
            VStack(spacing: 21) {
                Image(systemName: "film.stack")
                    .font(.system(size: 33, weight: .medium))
                    .foregroundStyle(Color(red: 0.16, green: 0.38, blue: 0.74))
                    .frame(width: 77, height: 77)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 22))
                    .shadow(color: .black.opacity(0.07), radius: 15, y: 5)

                Text("ClipShift")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.12, green: 0.17, blue: 0.27))

                Text(german ? "Was möchtest du tun?" : "What would you like to do?")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(red: 0.27, green: 0.32, blue: 0.42))

                Text(german
                     ? "Neue MOV-Bildschirmaufnahmen automatisch in MP4 umwandeln."
                     : "Automatically convert new MOV screen recordings to MP4.")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                HStack(spacing: 12) {
                    Button(german ? "Installieren" : "Install") { perform(install: true) }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(red: 0.15, green: 0.41, blue: 0.78))
                        .controlSize(.large)
                        .frame(width: 170)

                    Button(german ? "Deinstallieren" : "Uninstall") { perform(install: false) }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .frame(width: 170)
                }
                .disabled(busy)

                Text(message.isEmpty
                     ? (german ? "Lokal · Kostenlos · Ohne Hintergrundabfrage" : "Local · Free · No periodic polling")
                     : message)
                    .font(.system(size: 11))
                    .foregroundStyle(message.isEmpty ? Color.secondary : Color(red: 0.19, green: 0.34, blue: 0.56))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 425)
                    .frame(minHeight: 35)
            }
            .padding(30)
        }
    }

    private func perform(install: Bool) {
        busy = true
        message = german ? "Wird ausgeführt …" : "Working …"
        DispatchQueue.global(qos: .userInitiated).async {
            let result = install ? ClipShiftManager.install(german: german) : ClipShiftManager.uninstall(german: german)
            DispatchQueue.main.async {
                message = result
                busy = false
            }
        }
    }
}

enum ClipShiftManager {
    static let identifier = "MP4-bei-neuer-MOV.scpt"
    static var base: URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Application Support/ScreenRecordingMP4", isDirectory: true)
    }
    static var actionDirectory: URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Scripts/Folder Action Scripts", isDirectory: true)
    }
    static var action: URL { actionDirectory.appendingPathComponent(identifier) }

    static func run(_ executable: String, _ arguments: [String]) -> (Int32, String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: executable)
        process.arguments = arguments
        let output = Pipe()
        process.standardOutput = output
        process.standardError = output
        do {
            try process.run()
            let data = output.fileHandleForReading.readDataToEndOfFile()
            process.waitUntilExit()
            return (process.terminationStatus, String(data: data, encoding: .utf8) ?? "")
        } catch {
            return (1, error.localizedDescription)
        }
    }

    static func findFFmpeg() -> Bool {
        let dirs = ["/opt/homebrew/bin", "/usr/local/bin", "/usr/bin"]
        return dirs.contains { dir in
            FileManager.default.isExecutableFile(atPath: dir + "/ffmpeg") &&
            FileManager.default.isExecutableFile(atPath: dir + "/ffprobe")
        }
    }

    static func install(german: Bool) -> String {
        guard findFFmpeg() else {
            return german ? "FFmpeg fehlt. Bitte zuerst im Terminal ausführen: brew install ffmpeg"
                          : "FFmpeg missing. First run in Terminal: brew install ffmpeg"
        }
        guard let shell = Bundle.main.url(forResource: "convert-folder-action", withExtension: "sh"),
              let source = Bundle.main.url(forResource: "folder-action", withExtension: "applescript") else {
            return german ? "Installationsdateien fehlen." : "Missing installation resources."
        }

        do {
            try FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: actionDirectory, withIntermediateDirectories: true)
            let destination = base.appendingPathComponent("convert-folder-action.sh")
            // Preserve the currently working implementation when reinstalling.
            if !FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.copyItem(at: shell, to: destination)
            }
            try FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: destination.path)
            if !FileManager.default.fileExists(atPath: action.path) {
                let compile = run("/usr/bin/osacompile", ["-o", action.path, source.path])
                guard compile.0 == 0 else { return compile.1 }
            }
            let attach = run("/usr/bin/osascript", ["-e", """
                tell application "System Events"
                    set folder actions enabled to true
                    set desktopPath to POSIX path of (path to desktop folder)
                    if not (exists folder action with path desktopPath) then
                        make new folder action at end of folder actions with properties {path:desktopPath}
                    end if
                    set targetAction to folder action with path desktopPath
                    if not (exists script "MP4-bei-neuer-MOV.scpt" of targetAction) then
                        make new script at end of scripts of targetAction with properties {name:"\(identifier)", path:"\(action.path)"}
                    end if
                end tell
                """])
            if attach.0 != 0 {
                return german
                    ? "Dateien installiert. Bitte in „Ordneraktionen konfigurieren“ das Skript MP4-bei-neuer-MOV.scpt dem Schreibtisch zuordnen. macOS kann eine Automationsfreigabe verlangen."
                    : "Files installed. In Folder Actions Setup, attach MP4-bei-neuer-MOV.scpt to Desktop. macOS may request Automation permission."
            }
            return german ? "Installiert! Neue MOV-Aufnahmen werden verarbeitet. Bereits vorhandene Dateien bleiben unverändert."
                          : "Installed! New MOV recordings will be processed. Existing files remain unchanged."
        } catch {
            return (german ? "Installation fehlgeschlagen: " : "Installation failed: ") + error.localizedDescription
        }
    }

    static func uninstall(german: Bool) -> String {
        // Do not remove unrelated folder actions, FFmpeg or personal recordings.
        _ = run("/usr/bin/osascript", ["-e", """
            tell application "System Events"
                set desktopPath to POSIX path of (path to desktop folder)
                if exists folder action with path desktopPath then
                    tell folder action with path desktopPath
                        if exists script "\(identifier)" then delete script "\(identifier)"
                    end tell
                end if
            end tell
            """])
        do {
            if FileManager.default.fileExists(atPath: action.path) {
                try FileManager.default.removeItem(at: action)
            }
            let shell = base.appendingPathComponent("convert-folder-action.sh")
            if FileManager.default.fileExists(atPath: shell.path) {
                try FileManager.default.removeItem(at: shell)
            }
            let toggle = base.appendingPathComponent("delete-original-after-success.enabled")
            if FileManager.default.fileExists(atPath: toggle.path) {
                try FileManager.default.removeItem(at: toggle)
            }
            return german ? "Deinstalliert. FFmpeg, Videos und andere Ordneraktionen bleiben erhalten."
                          : "Uninstalled. FFmpeg, videos and other folder actions are preserved."
        } catch {
            return (german ? "Deinstallation unvollständig: " : "Uninstall incomplete: ") + error.localizedDescription
        }
    }
}
