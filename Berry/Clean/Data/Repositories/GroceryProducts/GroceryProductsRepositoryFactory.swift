import Foundation

enum GroceryProductsRepositoryFactory {
    static func make() -> GroceryProductsRepository {
        let restClient = RESTClient()
        let dataSource = GroceryProductsDataSourceImplementation(networkClient: restClient)
        
        return GroceryProductsRepositoryImplementation(groceryProductsDataSource: dataSource)
    }
}
