import Foundation
import VisionKit
import Vision

extension Ticket {
    struct ItemsAnalyser {
        let rewaAlgorithm: RewaAlgorithm
        
        func process(observations: [VNRecognizedTextObservation], for grocery: Grocery) -> [Item] {
            switch grocery {
            case .rewe:
                return rewaAlgorithm.process(observations: observations)
            }
        }
    }
}
