import SwiftUI

struct ResultsView: View {
    let ticket: Ticket
    let formatStyle: any FormatStyle = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(ticket.items, id: \.name) {
                    rowItem(item: $0)
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func rowItem(item: Ticket.Item) -> some View {
        HStack {
            Text(item.name)
            
            Spacer()
            
            Text(item.price, format: .currency(code: "EUR").precision(.fractionLength(2)))
            Text("x")
            Text(item.quantity, format: .number)
            Text("=")
            Text(item.totalPrice, format: .currency(code: "EUR").precision(.fractionLength(2)))
                .fontWeight(.bold)
                .padding(10)
                .background(Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color.gray.opacity(0.6).ignoresSafeArea()
        
        ResultsView(ticket: .previewMock)
    }
}
#endif
