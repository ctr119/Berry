import Foundation
import VisionKit
import Vision

extension Ticket {
    struct Scanner {
        enum RecognizerError: Error {
            case failToCastObservations
        }
        
        private let groceryAnalyser: GroceryAnalyser
        private let analyser: Analyser
        
        init(
            groceryAnalyser: GroceryAnalyser,
            analyser: Analyser
        ) {
            self.groceryAnalyser = groceryAnalyser
            self.analyser = analyser
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
                        continuation.resume(throwing: RecognizerError.failToCastObservations)
                        return
                    }
                    
                    var topToBottomObservations = observations.sorted { lhs, rhs in
                        lhs.boundingBox.minY > rhs.boundingBox.minY
                    }
                    
                    let grocery = groceryAnalyser.title(topToBottomObservations.removeFirst())
                    
                    let items = analyser.process(observations: topToBottomObservations)
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
