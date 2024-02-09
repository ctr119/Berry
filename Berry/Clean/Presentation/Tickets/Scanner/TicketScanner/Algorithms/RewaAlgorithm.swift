import Foundation
import Vision

class RewaAlgorithm: ItemsAlgorithm {
    private let itemsSectionStart = "EUR"
    private let itemsSectionEnd = "-------"
    private var inItemsSection = false
    
    private var items = [Ticket.Item]()
    
    private var auxName: String?
    private var auxTotalPrice: Double?
    private var auxPrice: Double?
    private var auxQuantity: Int?
    private var auxWeight: String?
    
    func process(observations: [VNRecognizedTextObservation]) -> [Ticket.Item] {
        let maximumCandidates = 1
        
        let observationBaselineThreshold = 0.04
        var previousObservation: VNRecognizedTextObservation?
        
        let observationIdentationThreshold: CGFloat = 3
        
        for observation in observations {
            guard let text = observation.topCandidates(maximumCandidates).first?
                .string
                .trimmingCharacters(in: .whitespacesAndNewlines),
                  isInItemsSection(text: text)
            else { continue }
            
            if let previousObservation {
                let doesBelongToTheSameBaseline = abs(observation.boundingBox.minY - previousObservation.boundingBox.minY) < observationBaselineThreshold
                if doesBelongToTheSameBaseline {
                    if let totalPrice = totalPrice(from: text) {
                        auxTotalPrice = totalPrice
                    }
                    continue
                } else {
                    let hasIdentation = abs(observation.boundingBox.minX - previousObservation.boundingBox.minX) > observationIdentationThreshold
                    if hasIdentation {
                        if let tuple = weightTuple(from: text) {
                            auxPrice = tuple.price
                            auxWeight = tuple.weight
                        } else if let tuple = quantityTuple(from: text) {
                            auxPrice = tuple.price
                            auxQuantity = tuple.quantity
                        }
                        
                        saveItem()
                        continue
                    } else {
                        saveItem()
                    }
                }
            }
            
            auxName = text
            previousObservation = observation
        }
        
        return items
    }
    
    private func isInItemsSection(text: String) -> Bool {
        if !inItemsSection && text.contains(itemsSectionStart) {
            inItemsSection = true
            return false // skip this one as it contains the starting indicator
        }
        return inItemsSection
    }
    
    private func totalPrice(from text: String) -> Double? {
        let totalPriceComponents = text
            .replacingOccurrences(of: ",", with: ".")
            .components(separatedBy: .whitespaces)
        
        guard let totalPriceString = totalPriceComponents.first else {
            return nil
        }
        
        return Double(totalPriceString)
    }
    
    private func weightTuple(from text: String) -> (weight: String, price: Double)? {
        let regex = /(?<weight>[\d.]+ kg) +x +(?<price>[\d.]+)/
        let replacedText = text.replacingOccurrences(of: ",", with: ".")
        
        guard let result = try? regex.wholeMatch(in: replacedText),
              let price = Double(result.output.price) else { return nil }
        
        return (String(result.output.weight), price)
    }
    
    private func quantityTuple(from text: String) -> (quantity: Int, price: Double)? {
        let regex = /(?<quantity>[\d]+) +\w+ x +(?<price>[\d.]+)/
        let replacedText = text.replacingOccurrences(of: ",", with: ".")
        
        guard let result = try? regex.wholeMatch(in: replacedText),
              let quantity = Int(result.output.quantity),
              let price = Double(result.output.price) else { return nil }
        
        return (quantity, price)
    }
    
    private func saveItem() {
        guard let auxName, let auxTotalPrice, let auxPrice else {
            clearState()
            return
        }
        
        let item = Ticket.Item(
            name: auxName,
            quantity: auxQuantity,
            weight: auxWeight,
            price: auxPrice,
            totalPrice: auxTotalPrice
        )
        
        items.append(item)
        clearState()
    }
    
    private func clearState() {
        auxName = nil
        auxTotalPrice = nil
        auxPrice = nil
        auxQuantity = nil
        auxWeight = nil
    }
}
