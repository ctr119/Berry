import Foundation

protocol GroceryProductsRepository {
    func classify(products: [String]) async throws -> [(productName: String, category: String)]
}

struct GroceryProductsRepositoryImplementation: GroceryProductsRepository {
    private let groceryProductsDataSource: GroceryProductsDataSource
    
    init(groceryProductsDataSource: GroceryProductsDataSource) {
        self.groceryProductsDataSource = groceryProductsDataSource
    }
    
    func classify(products: [String]) async throws -> [(productName: String, category: String)] {
        let classifiedProducts = try await groceryProductsDataSource.classify(productNames: products)
        return classifiedProducts.map { (productName: $0.title, category: $0.category) }
    }
}
