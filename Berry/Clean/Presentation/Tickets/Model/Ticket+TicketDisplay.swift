import Foundation

extension Ticket {
    var toDisplay: TicketDisplay {
        .init(
            groceryName: self.grocery.rawValue,
            items: self.items.map { $0.toDisplay }
        )
    }
}

extension Ticket.Item {
    var toDisplay: TicketDisplay.Item {
        .init(
            name: self.name,
            quantity: self.quantity,
            weight: self.weight,
            price: self.price,
            totalPrice: self.totalPrice,
            category: self.category
        )
    }
}
