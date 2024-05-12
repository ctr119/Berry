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
        
        // TODO: Load existing Categories from DDBB
        
        // TODO: Once, the ticket is saved, add those new added categories into the DDBB
    }
}
