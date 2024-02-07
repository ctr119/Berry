import Foundation
import VisionKit
import Vision

extension Ticket {
    struct ItemsAnalyser {
        let algorithmProvider: (Grocery) -> ItemsAlgorithm
        
        func process(observations: [VNRecognizedTextObservation], for grocery: Grocery) -> [Item] {
            let algorithm = algorithmProvider(grocery)
            return algorithm.process(observations: observations)
        }
    }
}
