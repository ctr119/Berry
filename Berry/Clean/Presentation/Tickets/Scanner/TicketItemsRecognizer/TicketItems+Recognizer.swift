import Foundation
import VisionKit
import Vision

extension TicketItems {
    struct Recognizer {
        enum RecognizerError: Error {
            case failToCastObservations
        }
        
        private let analyser: TicketItems.Analyser
        
        init(analyser: TicketItems.Analyser) {
            self.analyser = analyser
        }
        
        func items(in cgImage: CGImage) async throws -> [Ticket.Item] {
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
                    
                    let topToBottomObservations = observations.sorted { lhs, rhs in
                        lhs.boundingBox.minY > rhs.boundingBox.minY
                    }
                    
                    let items = analyser.process(observations: topToBottomObservations)
                    continuation.resume(returning: items)
                }
                
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
