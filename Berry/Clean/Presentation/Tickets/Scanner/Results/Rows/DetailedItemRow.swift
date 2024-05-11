import SwiftUI

struct DetailedItemRow: View {
    @State private var selectedCategory: String = ""
    private let categories = ["Meat", "Fish"]
    private let verticalSpacing: CGFloat = 8
    
    @Binding var item: TicketDisplay.Item
    
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
        let binding = Binding(
            get: {
                return selectedCategory
            },
            set: {
                selectedCategory = $0
                self.item.category = $0
            }
        )
        
        return VStack(alignment: .leading, spacing: verticalSpacing) {
            Text(item.name)
                .font(.headline)
            
            Menu {
                Picker("", selection: binding) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.inline)
            } label: {
                Text(categoryString)
                    .font(.caption.lowercaseSmallCaps())
                    .fontWeight(.regular)
                    .underline()
            }
        }
        .pickerStyle(.menu)
    }
    
    private var categoryString: String {
        (item.category ?? "unknown").capitalized
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
    @State var item: TicketDisplay.Item = .previewMock
    
    return ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        
        DetailedItemRow(item: $item)
    }
}
#endif
