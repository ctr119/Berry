import Foundation

protocol ItemsAlgorithm {
    func process(lines: [String]) -> [Ticket.Item]
}
