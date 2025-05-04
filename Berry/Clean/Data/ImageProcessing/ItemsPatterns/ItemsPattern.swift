import Foundation

protocol ItemsPattern {
    func parse(lines: [String]) -> [ScannedItemDTO]
}
