import SwiftUI

extension ResultsView {
    @Observable
    class ViewModel {
        var ticket: TicketDisplay
        var existingCategories: [String] = [
            "Meat", "Fish"
        ]
        
        init(ticket: TicketDisplay) {
            self.ticket = ticket
        }
    }
}
