import Foundation

protocol TicketAlgorithm {
    func process(lines: [String]) -> [Ticket.Item]
}
