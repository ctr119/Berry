import Foundation

class Ticket {
    struct Item: Hashable {
        let name: String
        let quantity: String
        let price: String
        let totalPrice: String
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.name == rhs.name
                && lhs.quantity == rhs.quantity
                && lhs.price == rhs.price
                && lhs.totalPrice == rhs.totalPrice
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(quantity)
            hasher.combine(price)
            hasher.combine(totalPrice)
        }
    }
    
    private(set) var items: [Item] = []
    
    func add(items: [Item]) {
        self.items.append(contentsOf: items)
    }
}
