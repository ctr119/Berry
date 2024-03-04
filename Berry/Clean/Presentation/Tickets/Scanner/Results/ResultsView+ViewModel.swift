import SwiftUI

extension ResultsView {
    @Observable
    class ViewModel {
        var categories: [Food.Category] = []
        var categoryBoxes: [Food.Category: [Ticket.Item]] = [:]
        
        func didTapOnAddCategory() {
            categories.append(.bakery)
        }
    }
}
