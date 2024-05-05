import Foundation
import Vision

class RewaAlgorithm: TicketAlgorithm {
    private let itemsSectionStart = "EUR"
    private let itemsSectionEnd = "-------"
    private var inItemsSection = false
    
    func process(lines: [String]) -> [Ticket.Item] {
        var items = [Ticket.Item]()
        
        var auxName: String?
        var auxTotalPrice: Double?
        var auxPrice: Double?
        var auxQuantity: Int? = 1
        var auxWeight: String?
        
        func clearState() {
            auxName = nil
            auxTotalPrice = nil
            auxPrice = nil
            auxQuantity = 1
            auxWeight = nil
        }
        
        func saveItem() {
            guard let auxName, let auxTotalPrice else {
                clearState()
                return
            }
            
            let item = Ticket.Item(
                name: auxName,
                quantity: auxQuantity,
                weight: auxWeight,
                price: auxPrice ?? auxTotalPrice,
                totalPrice: auxTotalPrice
            )
            
            items.append(item)
            clearState()
        }
        
        for line in lines {
            guard isInItemsSection(text: line) else { continue }
            guard !isTheEndOfTheSection(text: line) else { break }
            
            if let singleItem = singleItem(from: line) {
                if auxName != nil, auxTotalPrice != nil {
                    saveItem()
                }
                
                auxName = singleItem.name
                auxTotalPrice = singleItem.totalPrice
                
            } else if let quantityItem = quantityTuple(from: line) {
                auxQuantity = quantityItem.quantity
                auxPrice = quantityItem.price
                
            } else if let weightItem = weightTuple(from: line) {
                auxQuantity = nil
                auxWeight = weightItem.weight
                auxPrice = weightItem.price
            }
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
    
    private func isTheEndOfTheSection(text: String) -> Bool {
        text.contains(itemsSectionEnd)
    }
    
    private func singleItem(from text: String) -> (name: String, totalPrice: Double)? {
        let regex = /(?<name>[^\d\n]+.*) +(?<totalPrice>-?[\d.]+) (?!EUR\/kg)/
        let replacedText = text.replacingOccurrences(of: ",", with: ".")
        
        guard let result = try? regex.firstMatch(in: replacedText),
              let totalPrice = Double(result.output.totalPrice) else { return nil }
        
        return (String(result.output.name), totalPrice)
    }
    
    private func quantityTuple(from text: String) -> (quantity: Int, price: Double)? {
        let regex = /(?<quantity>\d+?) +Stk x +(?<price>[\d.]+)/
        let replacedText = text.replacingOccurrences(of: ",", with: ".")
        
        guard let result = try? regex.wholeMatch(in: replacedText),
              let quantity = Int(result.output.quantity),
              let price = Double(result.output.price) else { return nil }
        
        return (quantity, price)
    }
    
    private func weightTuple(from text: String) -> (weight: String, price: Double)? {
        let regex = /(?<weight>[\d.]+ [\D]+) +x +(?<price>[\d.]+) +[\D]+/
        let replacedText = text.replacingOccurrences(of: ",", with: ".")
        
        guard let result = try? regex.wholeMatch(in: replacedText),
              let price = Double(result.output.price) else { return nil }
        
        let weight = String(result.output.weight).replacingOccurrences(of: ".", with: ",")
        
        return (weight, price)
    }
}
