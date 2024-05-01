import Foundation
import Vision

struct GroceryAnalyser {
    func title(_ observation: VNRecognizedTextObservation) -> Grocery? {
        guard let text = observation.topCandidates(1).first?
            .string
            .trimmingCharacters(in: .whitespacesAndNewlines)
        else { return nil }
        
        return Grocery(rawValue: text)
    }
}
