import Foundation

enum PlaceholderCatAsset {
    static var text: String {
        guard let url = Bundle.module.url(forResource: "placeholder-cat", withExtension: "txt"),
              let contents = try? String(contentsOf: url, encoding: .utf8)
        else {
            return "(=^.^=)"
        }

        return contents.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
