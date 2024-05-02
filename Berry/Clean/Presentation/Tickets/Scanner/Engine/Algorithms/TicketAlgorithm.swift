import Foundation

protocol TicketAlgorithm {
    func process(lines: [String]) -> [TicketDisplay.Item]
}
