import Foundation

protocol ProductsRepository {
    func classify(products: [String]) async throws -> [(productName: String, category: String)]
}

struct ProductsRepositoryImplementation: ProductsRepository {
    private let productsDataSource: ProductsDataSource
    
    init(productsDataSource: ProductsDataSource) {
        self.productsDataSource = productsDataSource
    }
    
    func classify(products: [String]) async throws -> [(productName: String, category: String)] {
        let classifiedProducts = try await productsDataSource.classify(productNames: products)
        return classifiedProducts.map { (productName: $0.title, category: $0.category) }
    }
}
