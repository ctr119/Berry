import Foundation
import Vision
import VisionKit

protocol ImageProcessingRepository {
    func process(image cgImage: CGImage) async throws -> Ticket
}

class ImageProcessingRepositoryImplementation: ImageProcessingRepository {
    private let groceryAnalyser: GroceryAnalyser
    private let itemsAnalyser: ItemsAnalyser
    private let productsRepository: ProductsRepository
    private let ticketItemConverter: TicketItemConverter = .init()
    
    init(
        groceryAnalyser: GroceryAnalyser,
        itemsAnalyser: ItemsAnalyser,
        productsRepository: ProductsRepository
    ) {
        self.groceryAnalyser = groceryAnalyser
        self.itemsAnalyser = itemsAnalyser
        self.productsRepository = productsRepository
    }
    
    func process(image cgImage: CGImage) async throws -> Ticket {
        let (grocery, scannedItems) = try await recogniseText(in: cgImage)
        let itemNames = scannedItems.map { $0.name }
        
        let classifiedProducts = try await self.productsRepository.classify(products: itemNames)
        
        let items: [Ticket.Item] = scannedItems.compactMap {
            guard let category = classifiedProducts[$0.name] else { return nil }
            return self.ticketItemConverter.convert(scannedItemDto: $0, category: category)
        }
        
        return Ticket(grocery: grocery, items: items)
    }
    
    private func recogniseText(in cgImage: CGImage) async throws -> (grocery: Grocery, items: [ScannedItemDTO]) {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
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
                
                let scannedItemDtos = self.itemsAnalyser.analyse(observations: sortedObservations, for: grocery)
                continuation.resume(returning: (grocery, scannedItemDtos))
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
}
