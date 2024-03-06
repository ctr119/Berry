import SwiftUI

extension ResultsView {
    @Observable
    class ViewModel {
        var categories: [Food.Category] = []
        var itemsPerCategory: [Food.Category: [Ticket.Item]] = [:]
        
        func add(category: Food.Category) {
            guard !categories.contains(category) else { return }
            categories.append(category)
        }
    }
}
