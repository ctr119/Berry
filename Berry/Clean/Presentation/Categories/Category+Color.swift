import Foundation
import SwiftUI

extension Food.Category {
    var color: Color {
        let colorName = switch self {
        case .beverages:
            "Colors/beverages"
        default:
            "Colors/\(self)"
        }
        
        return Color(colorName, bundle: nil)
    }
    
    // TODO: Update the structure of the xcassets to hold both background and foreground
    var backgroundColor: Color {
        let colorName = switch self {
        case .beverages:
            "Colors/beverages"
        default:
            "Colors/\(self)"
        }
        
        return Color(colorName, bundle: nil)
    }
}
