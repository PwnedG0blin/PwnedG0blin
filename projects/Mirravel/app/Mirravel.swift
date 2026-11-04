// Copyright (c) 2026 PwnedG0blin · SPDX-License-Identifier: MIT
import AppKit
import SwiftUI

@main
struct Mirravel: App {
    var body: some Scene {
        Window("Mirravel", id: "main") {
            Dashboard()
        }
        .windowResizability(.contentSize)
    }
}

@MainActor
private struct Dashboard: View {
    @AppStorage("lastMacBuild") private var lastBuild = ""
    @AppStorage("lastPatchState") private var lastState = ""
    @State private var diagnosis: Diagnosis?
    @State private var buildNotice = ""
    @State private var message = ""
    @State private var busy = false
    @State private var confirmApply = false
    @State private var confirmRestore = false
    @State private var release: Release?
    @State private var releaseMessage = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Mirravel").font(.largeTitle.bold())
                Text("iPhone Mirroring · Version \(installedVersion)").foregroundStyle(.secondary)
            }
            GroupBox {
                VStack(alignment: .leading, spacing: 9) {
                    Label(diagnosis?.title ?? "Diagnose ausstehend", systemImage: diagnosis?.state == "patched" ? "checkmark.circle" : "info.circle")
                        .font(.headline)
                    if let diagnosis {
                        Text(diagnosis.report).font(.system(.caption, design: .monospaced)).textSelection(.enabled)
                    }
                    if !buildNotice.isEmpty { Text(buildNotice).font(.callout) }
                    Text("Die lokalen Werte allein bestätigen keine Verbindung zum iPhone.").foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(6)
            }
            HStack {
                Button("Diagnose") { run { await refresh() } }
                Button("Anwenden") { confirmApply = true }
                    .disabled(diagnosis?.state != "eligible-for-patch")
                Button("Wiederherstellen") { confirmRestore = true }
                Button("iPhone Mirroring öffnen") { openMirroring() }
            }
            .disabled(busy)
            if let diagnosis {
                Button("Diagnose kopieren") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(diagnosis.report, forType: .string)
                    message = "Diagnose kopiert."
                }
            }
            if !message.isEmpty { Text(message).textSelection(.enabled) }
            Divider()
            HStack {
                Button("Auf Updates prüfen") { run { await checkUpdates() } }
                    .disabled(busy)
                if let release {
                    Link("Release auf GitHub öffnen", destination: release.url)
                }
                Spacer()
                Button("Anleitung") {
                    if let url = Bundle.main.url(forResource: "Anleitung", withExtension: "txt") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
            if !releaseMessage.isEmpty { Text(releaseMessage).foregroundStyle(.secondary) }
            if busy { ProgressView().controlSize(.small) }
        }
        .padding(26)
        .frame(width: 620)
        .fixedSize(horizontal: false, vertical: true)
        .task { run { await refresh() } }
        .alert("Experimentellen Patch anwenden?", isPresented: $confirmApply) {
            Button("Abbrechen", role: .cancel) {}
            Button("Anwenden") { run { await change("apply") } }
        } message: {
            Text("Mirravel sichert und ändert drei lokale Freigabewerte. macOS fragt nach Administratorrechten.")
        }
        .alert("Gesicherte Werte wiederherstellen?", isPresented: $confirmRestore) {
            Button("Abbrechen", role: .cancel) {}
            Button("Wiederherstellen") { run { await change("restore") } }
        } message: {
            Text("Nur Mirravels drei gesicherte Werte für den aktuellen macOS-Build werden zurückgeschrieben.")
        }
    }

    private var installedVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    private func run(_ action: @escaping @MainActor () async -> Void) {
        guard !busy else { return }
        busy = true
        Task { @MainActor in
            defer { busy = false }
            await action()
        }
    }

    private func refresh() async {
        guard let output = await runCore("status"), output.success,
              let current = Diagnosis(output.text) else {
            diagnosis = nil
            message = "Diagnose fehlgeschlagen."
            return
        }
        diagnosis = current
        if !lastBuild.isEmpty && current.build != lastBuild {
            buildNotice = "macOS-Build gewechselt: \(lastBuild) → \(current.build)."
            if lastState == "patched" && current.state == "eligible-for-patch" {
                buildNotice += " Die zuvor beobachteten Patch-Werte sind nicht mehr vollständig gesetzt."
            }
        }
        lastBuild = current.build
        lastState = current.state
    }

    private func change(_ command: String) async {
        guard let output = await runCore(command, administrator: true) else {
            message = "Der Systemdialog konnte nicht gestartet werden."
            return
        }
        message = output.text.isEmpty ? "Vorgang beendet." : output.text
        await refresh()
    }

    private func openMirroring() {
        let url = URL(fileURLWithPath: "/System/Applications/iPhone Mirroring.app")
        NSWorkspace.shared.openApplication(at: url, configuration: .init()) { _, error in
            if error != nil {
                Task { @MainActor in message = "iPhone Mirroring konnte nicht geöffnet werden." }
            }
        }
    }

    private func checkUpdates() async {
        release = nil
        releaseMessage = ""
        do {
            guard let installed = ReleaseVersion(installedVersion) else { throw UpdateError.invalidVersion }
            guard let latest = try await Release.latest() else {
                releaseMessage = "Keine stabile Mirravel-Version auf GitHub gefunden."
                return
            }
            if latest.version > installed {
                release = latest
                releaseMessage = "Mirravel \(latest.version.label) ist verfügbar."
            } else {
                releaseMessage = "Kein neueres stabiles Mirravel-Release verfügbar."
            }
        } catch {
            releaseMessage = "GitHub-Updates konnten nicht geprüft werden. Bitte später erneut versuchen."
        }
    }
}

private struct Diagnosis {
    let report: String
    let state: String
    let build: String

    init?(_ output: String) {
        let lines = output.split(separator: "\n")
        guard let header = lines.first, lines.count > 2,
              let buildLine = lines.first(where: { $0.hasPrefix("Build: ") }) else { return nil }
        state = String(header)
        build = String(buildLine.dropFirst("Build: ".count))
        report = lines.dropFirst().joined(separator: "\n")
    }

    var title: String {
        switch state {
        case "patched": "Bekannte Freigabewerte gesetzt"
        case "eligible-for-patch": "Bekanntes Format · Patch nicht vollständig gesetzt"
        case "mixed": "Mac meldet berechtigt · Abweichende Statuswerte"
        case "unreadable": "Datei unlesbar · Full Disk Access für Mirravel prüfen"
        case "missing": "Keine bekannte Eligibility-Datei gefunden"
        default: "Unbekannte Eligibility-Struktur · Patch gesperrt"
        }
    }
}

private func runCore(_ command: String, administrator: Bool = false) async -> (success: Bool, text: String)? {
    guard let script = Bundle.main.url(forResource: "core", withExtension: "sh") else { return nil }
    return await Task.detached(priority: .userInitiated) { () -> (success: Bool, text: String)? in
        let process = Process()
        if administrator {
            process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
            process.arguments = ["-e", """
                on run argv
                    set scriptPath to quoted form of (item 1 of argv)
                    set actionName to quoted form of (item 2 of argv)
                    do shell script ("/bin/bash " & scriptPath & " " & actionName) with administrator privileges
                end run
                """, script.path, command]
        } else {
            process.executableURL = URL(fileURLWithPath: "/bin/bash")
            process.arguments = [script.path, command]
        }
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        do { try process.run() } catch { return nil }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        let output = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
        return (process.terminationStatus == 0, output)
    }.value
}
