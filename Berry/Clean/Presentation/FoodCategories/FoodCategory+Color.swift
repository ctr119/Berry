import Foundation
import SwiftUI

extension Food.Category {
    var foregroundColor: Color {
        switch self {
        case .frozen, .herbsAndSpices, .meat, .legumes, .seafood, .other:
            Color.white
        default:
            Color.black
        }
    }
    
    var backgroundColor: Color {
        let colorName = switch self {
        case .beverages(let bev):
            "beverages/\(bev)"
        default:
            "\(self)"
        }
        
        return Color(
            "Colors/\(colorName)",
            bundle: nil
        )
    }
}
