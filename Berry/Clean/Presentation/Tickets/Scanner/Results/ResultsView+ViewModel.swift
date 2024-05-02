import SwiftUI

extension ResultsView {
    @Observable
    class ViewModel {
        var categories: [Food.Category] = []
        var itemsPerCategory: [Food.Category: [TicketDisplay.Item]] = [:]
        let groceryName: String
        var ticketItems: [TicketDisplay.Item] = []
        
        init(ticket: TicketDisplay) {
            self.groceryName = ticket.groceryName
            self.ticketItems = ticket.items
        }
        
        func add(category: Food.Category) {
            guard !categories.contains(category) else { return }
            categories.append(category)
            itemsPerCategory[category] = []
        }
        
        func move(item: TicketDisplay.Item, to category: Food.Category) {
            guard var items = itemsPerCategory[category],
                  !items.contains(item) else { return }
            
            ticketItems.removeAll(where: { $0.name == item.name })
            
            items.append(item)
            itemsPerCategory[category] = items
        }
    }
}
