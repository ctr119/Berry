import Foundation
import VisionKit
import Vision

extension Ticket {
    struct Analyser {
        func process(observations: [VNRecognizedTextObservation]) -> [Item] {
            let maximumCandidates = 1
            var items = [Item]()
            var accumulatedTextPieces: [String] = []
            
            for observation in observations {
                guard let text = observation.topCandidates(maximumCandidates).first?
                    .string
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                else { continue }
                
                var textPieces = text
                    .components(separatedBy: .whitespaces)
                    .filter { !$0.isEmpty }
                
                if textPieces.count != 4 || accumulatedTextPieces.count > 0 {
                    accumulatedTextPieces.append(contentsOf: textPieces)
                    
                    if accumulatedTextPieces.count >= 4 {
                        textPieces = Array(accumulatedTextPieces.prefix(4))
                        accumulatedTextPieces.removeFirst(4)
                    } else {
                        continue
                    }
                }
                
                // TODO: Sort the pieces here (textPieces)
                
                if let item = buildItem(from: textPieces.joined(separator: " ")) {
                    items.append(item)
                }
            }
            
            return items
        }
        
        private func buildItem(from text: String) -> Item? {
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
