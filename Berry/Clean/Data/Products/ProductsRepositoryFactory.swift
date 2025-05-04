import Foundation

enum ProductsRepositoryFactory {
    static func make() -> ProductsRepository {
        let restClient = RESTClient()
        let dataSource = ProductsDataSourceImplementation(networkClient: restClient)
        
        return ProductsRepositoryImplementation(productsDataSource: dataSource)
    }
}
