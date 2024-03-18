import Foundation

extension Food {
    enum Category: Hashable, CaseIterable {
        static var allCases: [Category] {
            leafCategories +
            Beverages.allCases.map(Category.beverages)
        }
        
        private static let leafCategories: [Category] = [
            .bakery, .dairy, .dips, .eggs, .frozen, .fruits, .grain, .herbsAndSpices,
            .legumes, .meat, .pasta, .sauces, .seafood, .snacks, .ultraProcessed,
            .vegetables, .other
        ]
        
        enum Beverages: String, CaseIterable {
            case alcoholics
            case bottledWater
            case coffeeAndTea
            case energyDrinks
            case juice
            case milk
            case nutrition
            case softDrinks
            case sportsDrinks
            case veggies
        }
        
        case bakery
        case beverages(_ subcategory: Beverages)
        case dairy
        case dips
        case eggs
        case frozen
        case fruits
        case grain
        case herbsAndSpices
        case legumes
        case meat
        case pasta
        case sauces
        case seafood
        case snacks
        case ultraProcessed
        case vegetables
        case other
        
        var code: String {
            let categoryCode = switch self {
            case .beverages(let subcategory):
                "bev_\(subcategory)"
            case .herbsAndSpices:
                "h&s"
            default:
                String("\(self)".prefix(3))
            }
            
            return categoryCode.uppercased()
        }
        
        var title: String {
            return switch self {
            case .beverages(let subcategory):
                "Beverages/\(subcategory.rawValue.capitalized)"
            case .herbsAndSpices:
                "Herbs & Spices"
            default:
                "\(self)".capitalized
            }
        }
        
        var colorName: String {
            switch self {
            case .beverages:
                "Colors/beverages"
            default:
                "Colors/\(self)"
            }
        }
        
        // TODO: Add color in order to customize the Category Box
        
        init?(code: String) {
            for category in Category.allCases where category.code == code.uppercased() {
                self = category
                return
            }
            return nil
        }
    }
}
