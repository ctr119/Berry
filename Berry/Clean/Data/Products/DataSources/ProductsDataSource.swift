import Foundation

protocol ProductsDataSource {
    func classify(productNames: [String]) async throws -> [ClassifiedProductDTO]
}

struct ProductsDataSourceImplementation: ProductsDataSource {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func classify(productNames: [String]) async throws -> [ClassifiedProductDTO] {
        try await networkClient.perform(request: ClassifyProductsRequest(productNames: productNames))
    }
}
