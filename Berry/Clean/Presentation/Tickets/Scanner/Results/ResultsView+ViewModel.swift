import SwiftUI

extension ResultsView {
    @Observable
    class ViewModel {
        var ticket: TicketDisplay
        
        init(ticket: TicketDisplay) {
            self.ticket = ticket
        }
    }
}
