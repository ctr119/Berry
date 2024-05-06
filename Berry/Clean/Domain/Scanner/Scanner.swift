import Foundation
import VisionKit
import Vision

struct Scanner {
    enum ScannerError: Error {
        case failToCastObservations
        case nonSupportedGrocery
    }
    
    private let groceryAnalyser: GroceryAnalyser
    private let itemsAnalyser: ItemsAnalyser
    private let groceryProductsRepository: GroceryProductsRepository
    
    init(
        groceryAnalyser: GroceryAnalyser,
        itemsAnalyser: ItemsAnalyser,
        groceryProductsRepository: GroceryProductsRepository
    ) {
        self.groceryAnalyser = groceryAnalyser
        self.itemsAnalyser = itemsAnalyser
        self.groceryProductsRepository = groceryProductsRepository
    }
    
    func scanTicket(from cgImage: CGImage) async throws -> Ticket {
        let (items, grocery) = try await analyse(cgImage)
        let classifiedItems = await classify(items: items)
        
        return Ticket(groceryName: grocery.rawValue, items: classifiedItems)
    }
    
    private func analyse(_ cgImage: CGImage) async throws -> (items: [Ticket.Item], grocery: Grocery) {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: ScannerError.failToCastObservations)
                    return
                }
                
                // Sorted from top to bottom, and leading to trailing
                var sortedObservations = observations.sorted { lhs, rhs in
                    if lhs.doesBelongToTheSameBaseline(as: rhs) {
                        return lhs.boundingBox.minX < rhs.boundingBox.minX
                    } else {
                        return lhs.boundingBox.minY > rhs.boundingBox.minY
                    }
                }
                
                guard let grocery = groceryAnalyser.title(sortedObservations.removeFirst()) else {
                    continuation.resume(throwing: ScannerError.nonSupportedGrocery)
                    return
                }
                let items = itemsAnalyser.analyse(observations: sortedObservations, for: grocery)
                
                continuation.resume(returning: (items: items, grocery: grocery))
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
    
    private func classify(items: [Ticket.Item]) async -> [Ticket.Item] {
        var products: [String: Ticket.Item] = items.reduce(into: [:]) { partialResult, item in
            partialResult[item.name] = item
        }
        let productNames = Array(products.keys)
        
        guard let classifiedProducts = try? await groceryProductsRepository.classify(products: productNames) else {
            return items
        }
        
        for classifiedProduct in classifiedProducts {
            guard let product = products[classifiedProduct.productName] else { continue }
            product.category = classifiedProduct.category
            products[classifiedProduct.productName] = product
        }
        
        return Array(products.values)
    }
}
