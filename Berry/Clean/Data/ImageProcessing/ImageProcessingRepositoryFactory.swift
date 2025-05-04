enum ImageProcessingRepositoryFactory {
    static func make() -> ImageProcessingRepository {
        let itemsAnalyser = ItemsAnalyser(itemsPatternProvider: { grocery in
            switch grocery {
            case .rewe:
                RewaItemsPattern()
            }
        })
        
        return ImageProcessingRepositoryImplementation(
            groceryAnalyser: GroceryAnalyser(),
            itemsAnalyser: itemsAnalyser,
            productsRepository: ProductsRepositoryFactory.make()
        )
    }
}
