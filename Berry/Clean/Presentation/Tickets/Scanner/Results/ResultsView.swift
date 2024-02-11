import SwiftUI

struct ResultsView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    private let dynamicTypeSizeThreshold: DynamicTypeSize = .xxxLarge
    
    let ticket: Ticket
    let formatStyle: any FormatStyle = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(ticket.items, id: \.name) {
                            rowItem(item: $0)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(ticket.groceryName)
        }
    }
    
    @ViewBuilder
    private func rowItem(item: Ticket.Item) -> some View {
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
    private func priceSection(for item: Ticket.Item) -> some View {
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
    private func priceRow(for item: Ticket.Item) -> some View {
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
    
    private func quantityOrWeight(item: Ticket.Item) -> String {
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
    ResultsView(ticket: .previewMock)
}
#endif
