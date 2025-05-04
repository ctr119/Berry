import Foundation

protocol ItemsPattern {
    func parse(lines: [String]) -> [Ticket.Item]
}
