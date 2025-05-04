import Foundation

protocol ProductsRepository {
    func classify(products: [String]) async throws -> [String: String]
}

struct ProductsRepositoryImplementation: ProductsRepository {
    private let productsDataSource: ProductsDataSource
    
    init(productsDataSource: ProductsDataSource) {
        self.productsDataSource = productsDataSource
    }
    
    func classify(products: [String]) async throws -> [String: String] {
        // TODO: NEXT: Create a local DDBB with SwiftData <-
        // TODO: Locally store the categories for later suggest them to the user,
        // in case the category of one product couldn't be classified by the API
        
        let classifiedProducts = try await productsDataSource.classify(productNames: products)
        
        return classifiedProducts.reduce(into: [:]) { partialResult, classifiedProductDto in
            partialResult[classifiedProductDto.title] = classifiedProductDto.category
        }
    }
}
