import SwiftUI

struct DetailedItemRow: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    private let dynamicTypeSizeThreshold: DynamicTypeSize = .xxxLarge
    private let verticalSpacing: CGFloat = 8
    let item: TicketDisplay.Item
    
    var body: some View {
        HStack(alignment: .center) {
            textSection(for: item)
            
            Spacer()
            
            priceSection(for: item)
        }
        .monospaced()
        .frame(maxWidth: 400)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private func textSection(for item: TicketDisplay.Item) -> some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            Text(item.name)
                .font(.headline)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text((item.category ?? "unknown").capitalized)
                    .font(.caption.lowercaseSmallCaps())
                    .fontWeight(.regular)
                    .underline()
            })
            .buttonStyle(.plain)
        }
    }
    
    private func priceSection(for item: TicketDisplay.Item) -> some View {
        VStack(alignment: .trailing, spacing: verticalSpacing) {
            Text(item.totalPrice, format: .currency(code: "EUR").precision(.fractionLength(2)))
                .font(.headline)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack {
                Text(item.price, format: .currency(code: "EUR").precision(.fractionLength(2)))
                Text("x")
                Text(quantityOrWeight(item: item))
            }
            .font(.caption)
            .fontWeight(.light)
        }
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
    }
}
#endif
