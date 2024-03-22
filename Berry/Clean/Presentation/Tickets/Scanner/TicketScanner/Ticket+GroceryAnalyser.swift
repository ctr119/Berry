import Foundation
import Vision

// TODO: Rename all these classes under `TicketScanner` to `TicketProcessor`
extension Ticket {
    struct GroceryAnalyser {
        func title(_ observation: VNRecognizedTextObservation) -> Grocery? {
            guard let text = observation.topCandidates(1).first?
                .string
                .trimmingCharacters(in: .whitespacesAndNewlines)
            else { return nil }
            
            return Grocery(rawValue: text)
        }
    }
}
