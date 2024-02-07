import Foundation
import Vision

extension TicketItems {
    struct GroceryAnalyser {
        func title(_ observation: VNRecognizedTextObservation) -> SupportedGrocery? {
            guard let text = observation.topCandidates(1).first?
                .string
                .trimmingCharacters(in: .whitespacesAndNewlines)
            else { return nil }
            
            return SupportedGrocery(rawValue: text)
        }
    }
}
