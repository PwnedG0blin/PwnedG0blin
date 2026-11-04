// Copyright (c) 2026 PwnedG0blin · SPDX-License-Identifier: MIT
import Foundation

struct ReleaseVersion: Comparable {
    private let components: [Int]
    var label: String { components.map(String.init).joined(separator: ".") }

    init?(_ value: String) {
        let parts = value.split(separator: ".", omittingEmptySubsequences: false)
        let numbers = parts.compactMap { part -> Int? in
            guard !part.isEmpty, part.utf8.allSatisfy({ (48...57).contains($0) }) else { return nil }
            return Int(part)
        }
        guard parts.count == 3, numbers.count == 3 else { return nil }
        components = numbers
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.components.lexicographicallyPrecedes(rhs.components)
    }
}

enum UpdateError: Error {
    case invalidVersion, requestFailed
}

struct Release {
    let version: ReleaseVersion
    let url: URL

    private struct Entry: Decodable {
        let tag_name: String
        let draft: Bool
        let prerelease: Bool
    }

    static func latest() async throws -> Release? {
        let repository = "PwnedG0blin/PwnedG0blin"
        let prefix = "mirravel-v"
        var best: Release?
        for page in 1...10 {
            let endpoint = URL(string: "https://api.github.com/repos/\(repository)/releases?per_page=100&page=\(page)")!
            var request = URLRequest(url: endpoint, timeoutInterval: 10)
            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw UpdateError.requestFailed }
            let entries = try JSONDecoder().decode([Entry].self, from: data)
            for entry in entries where !entry.draft && !entry.prerelease && entry.tag_name.hasPrefix(prefix) {
                guard let version = ReleaseVersion(String(entry.tag_name.dropFirst(prefix.count))),
                      best.map({ version > $0.version }) ?? true,
                      let url = URL(string: "https://github.com/\(repository)/releases/tag/\(entry.tag_name)") else { continue }
                best = Release(version: version, url: url)
            }
            if entries.count < 100 { return best }
        }
        throw UpdateError.requestFailed
    }
}
