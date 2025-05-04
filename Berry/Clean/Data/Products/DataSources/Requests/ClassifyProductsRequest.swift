import Foundation

struct ClassifyProductsRequest: NetworkRequest {
    var path: String = "food/products/classifyBatch"
    var method: NetworkMethod = .POST
    
    var headers: [String : String] = [
        "Content-Type": "application/json"
    ]
    var parameters: [String : String] = [:]
    
    var body: Any? {
        var jsonBody: [[String: Any]] = []
        
        for name in productNames {
            jsonBody.append([
                "title": name,
                "upc": "",
                "plu_code": ""
            ])
        }
        
        return jsonBody
    }
    
    let productNames: [String]
}
