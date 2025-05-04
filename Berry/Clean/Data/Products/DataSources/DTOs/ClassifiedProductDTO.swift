import Foundation

struct ClassifiedProductDTO: Decodable {
    let title: String
    let image: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case title = "cleanTitle"
        case image
        case category
    }
}
