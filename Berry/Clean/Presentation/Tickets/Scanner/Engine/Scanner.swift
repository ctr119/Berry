import Foundation
import VisionKit
import Vision

/// TODO: Everything related to the Engine can be migrated to Domain
/// as it is basically a business logic: scanning & analysing the ticket.
///
/// However, the Object it returns, it's not a domain one...Let's start by
/// creating one!
///
/// TODO: Add another step into this use case: classify the items

struct Scanner {
    enum ScannerError: Error {
        case failToCastObservations
        case nonSupportedGrocery
    }
    
    private let groceryAnalyser: GroceryAnalyser
    private let itemsAnalyser: ItemsAnalyser
    
    init(
        groceryAnalyser: GroceryAnalyser,
        itemsAnalyser: ItemsAnalyser
    ) {
        self.groceryAnalyser = groceryAnalyser
        self.itemsAnalyser = itemsAnalyser
    }
    
    func ticket(from cgImage: CGImage) async throws -> TicketDisplay {
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
                
                let items = itemsAnalyser.process(observations: sortedObservations, for: grocery)
                let ticket = TicketDisplay(groceryName: grocery.rawValue, items: items)
                
                continuation.resume(returning: ticket)
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
