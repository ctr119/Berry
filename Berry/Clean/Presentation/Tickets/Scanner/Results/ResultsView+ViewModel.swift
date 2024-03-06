import SwiftUI

extension ResultsView {
    @Observable
    class ViewModel {
        var categories: [Food.Category] = []
        var itemsPerCategory: [Food.Category: [Ticket.Item]] = [:]
        
        func add(category: Food.Category) {
            guard !categories.contains(category) else { return }
            categories.append(category)
            itemsPerCategory[category] = []
        }
        
        func move(item: Ticket.Item, to category: Food.Category) {
            guard var items = itemsPerCategory[category],
                  !items.contains(item) else { return }
            
            // TODO: remove from the origin
            
            items.append(item)
            itemsPerCategory[category] = items
        }
    }
}
