import Foundation
import VisionKit
import Vision

extension TicketItems {
    struct Analyser {
        func process(observations: [VNRecognizedTextObservation]) -> [Ticket.Item] {
            let maximumCandidates = 1
            var items = [Ticket.Item]()
            
            for observation in observations {
                guard let text = observation.topCandidates(maximumCandidates).first?.string else { continue }
                
                if let item = buildItem(from: text) {
                    items.append(item)
                }
            }
            
            return items
        }
        
        private func buildItem(from text: String) -> Ticket.Item? {
            let regex = /(?<name>.+?) +(?<price>[\d,]+) +(?<quantity>\d+) +(?<totalPrice>[\d,]+)/

            guard let result = try? regex.wholeMatch(in: text) else { return nil }
            
            return .init(
                name: "\(result.output.name)",
                quantity: "\(result.output.quantity)",
                price: "\(result.output.price)",
                totalPrice: "\(result.output.totalPrice)"
            )
        }
    }
}
