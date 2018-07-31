import Foundation
public extension URL {
    init?(safe: String) {
        if safe.starts(with: "file:") {
            self.init(string: safe)
        } else {
            self.init(fileURLWithPath: safe)
        }
    }
}
