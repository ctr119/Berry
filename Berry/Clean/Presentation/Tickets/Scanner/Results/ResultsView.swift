import SwiftUI

struct ResultsView: View {
    @State var viewModel: ViewModel
        
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack {
                    GeometryReader { proxy in
                        ticketListItems(geometryProxy: proxy)
                    }
                }
            }
            .navigationTitle(viewModel.ticket.groceryName)
            .toolbar {
                // TODO: Replace for a "SAVE" button
                ToolbarItem(id: "add-category-item", placement: .primaryAction) {
                    Button(action: {
                        // TODO: Define the action
                    }, label: {
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
    private func ticketListItems(geometryProxy: GeometryProxy) -> some View {
        ScrollView {
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible()),
                    count: geometryProxy.size.width >= 900 ? 2 : 1
                )
            ) {
                ForEach(viewModel.ticket.items, id: \.name) {
                    DetailedItemRow(item: $0)
                }
            }
            .padding()
        }
    }
}

#if DEBUG
#Preview {
    ResultsView(
        viewModel: .init(ticket: .previewMock)
    )
}
#endif
