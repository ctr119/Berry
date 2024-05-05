import Foundation
import VisionKit
import Vision

struct ItemsAnalyser {
    let processorProvider: (Grocery) -> ItemsProcessor
    
    func analyse(observations: [VNRecognizedTextObservation], for grocery: Grocery) -> [Ticket.Item] {
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
        
        let itemsProcessor = processorProvider(grocery)
        return itemsProcessor.process(lines: lines)
    }
}
