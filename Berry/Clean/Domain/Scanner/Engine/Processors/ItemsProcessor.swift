import Foundation

protocol ItemsProcessor {
    func process(lines: [String]) -> [Ticket.Item]
}
