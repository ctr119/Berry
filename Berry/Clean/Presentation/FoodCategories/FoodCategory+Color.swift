import Foundation
import SwiftUI

extension Food.Category {
    var foregroundColor: Color {
        switch self {
        case .frozen, .legumes, .meat, .sauces, .seafood, .other:
            Color.white
        default:
            Color.black
        }
    }
    
    var backgroundColor: Color {
        Color("Colors/\(self)", bundle: nil)
    }
}
