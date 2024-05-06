import Foundation

protocol GroceryProductsDataSource {
    func classify(productNames: [String]) async throws -> [ClassifiedProductDTO]
}

struct GroceryProductsDataSourceImplementation: GroceryProductsDataSource {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func classify(productNames: [String]) async throws -> [ClassifiedProductDTO] {
        try await networkClient.perform(request: ClassifyProductsRequest(productNames: productNames))
    }
}
