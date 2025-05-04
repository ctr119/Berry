import Foundation

struct Ticket {
    let grocery: Grocery
    let items: [Item]
}

extension Ticket {
    class Item {
        let name: String
        let quantity: Int?
        let weight: String?
        let price: Double
        let totalPrice: Double
        var category: String?
        
        init(
            name: String,
            quantity: Int?,
            weight: String?,
            price: Double,
            totalPrice: Double,
            category: String?
        ) {
            self.name = name
            self.quantity = quantity
            self.weight = weight
            self.price = price
            self.totalPrice = totalPrice
            self.category = category
        }
    }
}
