import SwiftUI

extension ResultsView {
    @Observable
    class ViewModel {
        var categories: [Food.Category] = []
        var itemsPerCategory: [Food.Category: [Ticket.Item]] = [:]
        var ticket: Ticket
        
        init(ticket: Ticket) {
            self.ticket = ticket
        }
        
        func add(category: Food.Category) {
            guard !categories.contains(category) else { return }
            categories.append(category)
            itemsPerCategory[category] = []
        }
        
        func move(item: Ticket.Item, to category: Food.Category) {
            guard var items = itemsPerCategory[category],
                  !items.contains(item) else { return }
            
            print("Items: \(ticket.items.count)")
            ticket.remove(item: item)
            print("Items: \(ticket.items.count)")
            
            items.append(item)
            itemsPerCategory[category] = items
        }
    }
}
