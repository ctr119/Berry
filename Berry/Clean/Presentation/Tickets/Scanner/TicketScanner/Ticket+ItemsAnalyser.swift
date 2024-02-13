import Foundation
import VisionKit
import Vision

extension Ticket {
    struct ItemsAnalyser {
        let algorithmProvider: (Grocery) -> ItemsAlgorithm
        
        func process(observations: [VNRecognizedTextObservation], for grocery: Grocery) -> [Item] {
            let maximumCandidates = 1
            let observationBaselineThreshold = 0.01
            
            var previousObservation: VNRecognizedTextObservation?
            var currentLine: String = ""
            var lines: [String] = []
            
            for observation in observations {
                guard let text = observation.topCandidates(maximumCandidates).first?.string.trimmingCharacters(in: .whitespacesAndNewlines) else { continue }
                
                if let previousObservation {
                    let doesBelongToTheSameBaseline = abs(observation.boundingBox.minY - previousObservation.boundingBox.minY) < observationBaselineThreshold
                    if doesBelongToTheSameBaseline {
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
}
