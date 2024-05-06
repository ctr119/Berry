import Foundation

struct TicketDisplay {
    struct Item: Hashable, Codable {
        let name: String
        let quantity: Int?
        let weight: String?
        let price: Double
        let totalPrice: Double
        let category: String?
        
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
    let items: [Item]
}

#if DEBUG
extension TicketDisplay {
    static var previewMock: TicketDisplay = {
        return TicketDisplay(
            groceryName: "Mercadona",
            items: [
                .init(
                    name: "Milk",
                    quantity: 1,
                    weight: nil,
                    price: 6.45,
                    totalPrice: 6.45, 
                    category: "Dairy"
                ),
                .init(
                    name: "Chocolate",
                    quantity: 3,
                    weight: nil,
                    price: 1.99,
                    totalPrice: 5.97,
                    category: "Sweet"
                ),
                .init(
                    name: "Tomato sauce",
                    quantity: 3,
                    weight: nil,
                    price: 1.75,
                    totalPrice: 5.25,
                    category: nil
                ),
                .init(
                    name: "Oranges",
                    quantity: nil,
                    weight: "1,00 Kg",
                    price: 2.99,
                    totalPrice: 5.98,
                    category: "Fruit"
                )
            ]
        )
    }()
}

extension TicketDisplay.Item {
    static var previewMock: TicketDisplay.Item = .init(
        name: "Milk",
        quantity: 1,
        weight: nil,
        price: 6.45,
        totalPrice: 6.45,
        category: "Dairy"
    )
}
#endif
