import Foundation

struct Ticket {
    let groceryName: String
    let items: [Item]
}

extension Ticket {
    struct Item {
        let name: String
        let quantity: Int?
        let weight: String?
        let price: Double
        let totalPrice: Double
        // TODO: Add a category field - something to fill from Spoonacular
    }
}
