import SwiftUI

struct ResultsView: View {
    let ticket: Ticket
    let viewModel: ViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.categories, id: \.code) { category in
                                Rectangle()
                                    .frame(width: 100, height: 50)
                                    .foregroundStyle(.pink)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay {
                                        Text(category.title)
                                            .foregroundStyle(.white)
                                    }
                            }
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
                    Button(action: viewModel.didTapOnAddCategory, label: {
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
