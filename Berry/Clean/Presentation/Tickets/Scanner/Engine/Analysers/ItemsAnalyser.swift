import Foundation
import VisionKit
import Vision

struct ItemsAnalyser {
    let algorithmProvider: (Grocery) -> TicketAlgorithm
    
    func process(observations: [VNRecognizedTextObservation], for grocery: Grocery) -> [Ticket.Item] {
        let maximumCandidates = 1
        
        var previousObservation: VNRecognizedTextObservation?
        var currentLine: String = ""
        var lines: [String] = []
        
        for observation in observations {
            guard let text = observation.topCandidates(maximumCandidates).first?.string.trimmingCharacters(in: .whitespacesAndNewlines) else { continue }
            
            if let previousObservation {
                if observation.doesBelongToTheSameBaseline(as: previousObservation) {
                    currentLine += " \(text)"
                    continue
                } else {
                    lines.append(currentLine)
                }
            }
            
            currentLine = text
            previousObservation = observation
        }
        print("*** TICKET ***\n")
        for line in lines {
            print(line)
        }
        print("\n*** END ***")
        
        let algorithm = algorithmProvider(grocery)
        return algorithm.process(lines: lines)
    }
}
