import Foundation

enum NetworkMethod: String {
    case GET
    case POST
}

protocol NetworkRequest {
    var body: Any? { get }
    var headers: [String: String] { get }
    var method: NetworkMethod { get }
    var parameters: [String: String] { get }
    var path: String { get }
    var url: URL? { get }
}

extension NetworkRequest {
    var endpoint: String {
        "https://api.spoonacular.com/\(path)"
    }
    
    var url: URL? {
        guard var requestUrl = URL(string: endpoint) else { return nil }
        var queryItems: [URLQueryItem] = [
            .init(name: "apiKey", value: "92e5012a82f0445ea5c732da2747c58d"),
            .init(name: "locale", value: "en_US")
        ]
        
        for (key, value) in parameters {
            queryItems.append(
                URLQueryItem(name: key, value: value)
            )
        }
        
        if !queryItems.isEmpty {
            requestUrl.append(queryItems: queryItems)
        }
        
        return requestUrl
    }
    
    var urlRequest: URLRequest? {
        guard let url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        if let body, let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) {
            urlRequest.httpBody = jsonData
        }
        
        return urlRequest
    }
}
