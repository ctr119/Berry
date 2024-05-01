import Foundation

/// TODO: Move to Presentation
/// - This object will need a category field.
/// - Right now, this is being created from the Presentation layer, and from there we cannot assign a category directly.
/// - That's something manual for the time being by the user.
/// - That's why this will serve as a `TicketDisplay`, and later we will have a proper `Ticket` object to get passed to our repo.
class Ticket {
    struct Item: Hashable, Codable {
        let name: String
        let quantity: Int?
        let weight: String?
        let price: Double
        let totalPrice: Double
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.name == rhs.name
                && lhs.quantity == rhs.quantity
                && lhs.weight == rhs.weight
                && lhs.price == rhs.price
                && lhs.totalPrice == rhs.totalPrice
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(quantity)
            hasher.combine(weight)
            hasher.combine(price)
            hasher.combine(totalPrice)
        }
    }
    
    let groceryName: String
    private(set) var items: [Item] = []
    
    init(groceryName: String, items: [Item]) {
        self.groceryName = groceryName
        self.items = items
    }
}

#if DEBUG
extension Ticket {
    static var previewMock: Ticket = {
        return Ticket(
            groceryName: "Mercadona",
            items: [
                .init(
                    name: "Milk",
                    quantity: 1,
                    weight: nil,
                    price: 6.45,
                    totalPrice: 6.45
                ),
                .init(
                    name: "Chocolate",
                    quantity: 3,
                    weight: nil,
                    price: 1.99,
                    totalPrice: 5.97
                ),
                .init(
                    name: "Tomato sauce",
                    quantity: 3,
                    weight: nil,
                    price: 1.75,
                    totalPrice: 5.25
                ),
                .init(
                    name: "Oranges",
                    quantity: nil,
                    weight: "1,00 Kg",
                    price: 2.99,
                    totalPrice: 5.98
                )
            ]
        )
    }()
}

extension Ticket.Item {
    static var previewMock: Ticket.Item = .init(
        name: "Milk",
        quantity: 1,
        weight: nil,
        price: 6.45,
        totalPrice: 6.45
    )
}
#endif
