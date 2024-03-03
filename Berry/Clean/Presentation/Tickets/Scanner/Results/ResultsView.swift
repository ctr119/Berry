import SwiftUI

struct ResultsView: View {
    let ticket: Ticket
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            Rectangle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Rectangle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Rectangle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding()
                    }
                    
                    Divider()
                    
                    ticketListItems()
                }
            }
            .navigationTitle(ticket.groceryName)
            .toolbar {
                ToolbarItem(id: "add-category-item", placement: .primaryAction) {
                    Button(action: {}, label: {
                        Image(systemName: "plus.square.on.square")
                            .rotationEffect(.degrees(90))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.pink)
                    })
                }
            }
        }
    }
    
    @ViewBuilder
    private func ticketListItems() -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(ticket.items, id: \.name) {
                    Row(item: $0)
                }
            }
            .padding()
        }
    }
}

#if DEBUG
#Preview {
    ResultsView(ticket: .previewMock)
}
#endif
