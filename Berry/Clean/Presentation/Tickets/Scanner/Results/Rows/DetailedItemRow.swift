import SwiftUI

struct DetailedItemRow: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    private let dynamicTypeSizeThreshold: DynamicTypeSize = .xxxLarge
    let item: TicketDisplay.Item
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.headline)
            
            priceSection(for: item)
                .font(.subheadline)
                .frame(maxWidth: 400)
        }
        .monospaced()
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder
    private func priceSection(for item: TicketDisplay.Item) -> some View {
        HStack {
            Spacer()
            
            if dynamicTypeSize >= dynamicTypeSizeThreshold {
                VStack(alignment: .trailing) {
                    priceRow(for: item)
                }
            } else {
                priceRow(for: item)
            }
        }
    }
    
    @ViewBuilder
    private func priceRow(for item: TicketDisplay.Item) -> some View {
        Text(item.price, format: .currency(code: "EUR").precision(.fractionLength(2)))
        
        if dynamicTypeSize >= dynamicTypeSizeThreshold {
            HStack {
                Text("x")
                Spacer()
                Text(quantityOrWeight(item: item))
            }
            Divider()
        } else {
            Text("x")
            Text(quantityOrWeight(item: item))
            Text("=")
        }
        
        Text(item.totalPrice, format: .currency(code: "EUR").precision(.fractionLength(2)))
            .fontWeight(.bold)
            .padding(10)
            .background(Color.gray.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private func quantityOrWeight(item: TicketDisplay.Item) -> String {
        if let quantity = item.quantity {
            return "\(quantity)"
        }
        
        if let weight = item.weight {
            return weight
        }
        
        return ""
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        
        DetailedItemRow(item: .previewMock)
            .padding()
    }
}
#endif
