import Foundation
import VisionKit
import Vision

extension TicketItems {
    struct Analyser {
        func process(observations: [VNRecognizedTextObservation]) -> [Ticket.Item] {
            let maximumCandidates = 1
            var items = [Ticket.Item]()
            var accumulatedTextPieces: [String] = []
            
            for observation in observations {
                guard let text = observation.topCandidates(maximumCandidates).first?
                    .string
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                else { continue }
                
                var textToProcess = text
                let textPieces = textToProcess
                    .components(separatedBy: .whitespaces)
                    .filter { !$0.isEmpty }
                
                if textPieces.count != 4 || accumulatedTextPieces.count > 0 {
                    accumulatedTextPieces.append(contentsOf: textPieces)
                    
                    if accumulatedTextPieces.count >= 4 {
                        textToProcess = accumulatedTextPieces.prefix(4).joined(separator: " ")
                        accumulatedTextPieces.removeFirst(4)
                    } else {
                        continue
                    }
                }
                
                if let item = buildItem(from: textToProcess) {
                    items.append(item)
                }
            }
            
            return items
        }
        
        private func buildItem(from text: String) -> Ticket.Item? {
            let regex = /(?<name>.+?) +(?<price>[\d.]+) +(?<quantity>\d+) +(?<totalPrice>[\d.]+)/
            let replacedText = text.replacingOccurrences(of: ",", with: ".")
            
            guard let result = try? regex.wholeMatch(in: replacedText),
                  let quantity = Int(result.output.quantity),
                  let price = Double(result.output.price),
                  let totalPrice = Double(result.output.totalPrice) else { return nil }
            
            return .init(
                name: "\(result.output.name)",
                quantity: quantity,
                price: price,
                totalPrice: totalPrice
            )
        }
    }
}
