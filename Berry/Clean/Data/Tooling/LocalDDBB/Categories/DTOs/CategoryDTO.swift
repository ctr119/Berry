import Foundation
import SwiftData

@Model
class CategoryDTO {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
