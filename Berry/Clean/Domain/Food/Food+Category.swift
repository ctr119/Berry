import Foundation

extension Food {
    enum Category: Hashable, CaseIterable {
        case bakery
        case beverages
        case dairy
        case dips
        case frozen
        case fruits
        case grain
        case herbsAndSpices
        case legumes
        case meat
        case other
        case pasta
        case sauces
        case seafood
        case snacks
        case ultraProcessed
        case vegetables
        case veggies
        
        var code: String {
            let categoryCode = switch self {
            case .herbsAndSpices:
                "h&s"
            default:
                String("\(self)".prefix(3))
            }
            
            return categoryCode.uppercased()
        }
        
        var title: String {
            return switch self {
            case .herbsAndSpices:
                "Herbs & Spices"
            default:
                "\(self)".capitalized
            }
        }
        
        init?(code: String) {
            for category in Category.allCases where category.code == code.uppercased() {
                self = category
                return
            }
            return nil
        }
    }
}
