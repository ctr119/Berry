import Foundation
import VisionKit
import Vision

extension Ticket {
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
        
        func items(in cgImage: CGImage) async throws -> [Item] {
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
                    
                    var topToBottomObservations = observations.sorted { lhs, rhs in
                        lhs.boundingBox.minY > rhs.boundingBox.minY
                    }
                    
                    guard let grocery = groceryAnalyser.title(topToBottomObservations.removeFirst()) else {
                        continuation.resume(throwing: ScannerError.nonSupportedGrocery)
                        return
                    }
                    
                    let items = itemsAnalyser.process(observations: topToBottomObservations, for: grocery)
                    continuation.resume(returning: items)
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
}
