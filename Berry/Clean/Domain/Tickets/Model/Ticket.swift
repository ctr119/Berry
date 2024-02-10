import Foundation

class Ticket {
    struct Item: Hashable {
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
    
    init(groceryName: String) {
        self.groceryName = groceryName
    }
    
    func add(items: [Item]) {
        self.items.append(contentsOf: items)
    }
}

#if DEBUG
extension Ticket {
    static var previewMock: Ticket = {
        let ticket = Ticket(groceryName: "Mercadona")
        ticket.add(items: [
            .init(name: "Milk", quantity: 1, weight: nil, price: 6.45, totalPrice: 6.45),
            .init(name: "Chocolate", quantity: 3, weight: nil, price: 1.99, totalPrice: 5.97),
            .init(name: "Tomato sauce", quantity: 3, weight: nil, price: 1.75, totalPrice: 5.25),
            .init(name: "Oranges", quantity: nil, weight: "1,00 Kg", price: 2.99, totalPrice: 5.98)
        ])
        return ticket
    }()
}
#endif
