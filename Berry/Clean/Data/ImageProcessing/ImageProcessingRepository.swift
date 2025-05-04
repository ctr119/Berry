import Foundation
import Vision
import VisionKit

protocol ImageProcessingRepository {
    func process(image cgImage: CGImage) async throws -> Ticket
}

class ImageProcessingRepositoryImplementation: ImageProcessingRepository {
    private let groceryAnalyser: GroceryAnalyser
    private let itemsAnalyser: ItemsAnalyser
    
    init(groceryAnalyser: GroceryAnalyser, itemsAnalyser: ItemsAnalyser) {
        self.groceryAnalyser = groceryAnalyser
        self.itemsAnalyser = itemsAnalyser
    }
    
    func process(image cgImage: CGImage) async throws -> Ticket {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        // TODO: 1. Recognise text -> observations
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: Scanner.SError.failToCastObservations)
                    return
                }
                
                // Sort from top to bottom, and leading to trailing
                var sortedObservations = observations.sorted { lhs, rhs in
                    if lhs.doesBelongToTheSameBaseline(as: rhs) {
                        return lhs.boundingBox.minX < rhs.boundingBox.minX
                    } else {
                        return lhs.boundingBox.minY > rhs.boundingBox.minY
                    }
                }
                
                guard let grocery = self.groceryAnalyser.title(sortedObservations.removeFirst()) else {
                    continuation.resume(throwing: Scanner.SError.nonSupportedGrocery)
                    return
                }
                
                // TODO: 2. Analyse observations -> ScannedItemDTO
                let scannedItemDtos = self.itemsAnalyser.analyse(observations: sortedObservations, for: grocery)
                
                // TODO: 3. Classify scanned items -> Ticket.Item
                // TODO: NEXT: Create a local DDBB with SwiftData <-
                // TODO: Locally store the categories for later suggest them to the user,
                // in case the category of one product couldn't be classified by the API
                
                // TODO: 4. Compose the final Ticket object
                continuation.resume(
                    returning: Ticket(
                        groceryName: grocery.rawValue, // TODO: Refactor. Grocery enum instead of String
                        items: scannedItemDtos
                    )
                )
            }
            
            request.recognitionLevel = .accurate
            
            do {
                try requestHandler.perform([request])
            } catch {
                print("Unable to perform the requests: \(error).")
                continuation.resume(throwing: error)
            }
        }
    }
    
    // TODO: Left here for later
//    private func classify(items: [Ticket.Item]) async -> [Ticket.Item] {
//        var products: [String: Ticket.Item] = items.reduce(into: [:]) { partialResult, item in
//            partialResult[item.name] = item
//        }
//        let productNames = Array(products.keys)
//        
//        guard let classifiedProducts = try? await groceryProductsRepository.classify(products: productNames) else {
//            return items
//        }
//        
//        for classifiedProduct in classifiedProducts {
//            guard let product = products[classifiedProduct.productName] else { continue }
//            product.category = classifiedProduct.category
//            products[classifiedProduct.productName] = product
//        }
//        
//        return Array(products.values)
//    }
}
