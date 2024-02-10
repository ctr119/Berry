import SwiftUI

struct ResultsView: View {
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
        HStack {
            Text(item.name)
            
            Spacer()
            
            Text(item.price, format: .currency(code: "EUR").precision(.fractionLength(2)))
            Text("x")
            Text(quantityOrWeight(item: item))
            Text("=")
            Text(item.totalPrice, format: .currency(code: "EUR").precision(.fractionLength(2)))
                .fontWeight(.bold)
                .padding(10)
                .background(Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .monospaced()
        .padding()
        .background(.white)
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
