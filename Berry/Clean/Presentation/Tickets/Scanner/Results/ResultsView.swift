import SwiftUI

struct ResultsView: View {
    let ticket: Ticket
    let viewModel: ViewModel = .init()
    @State var localItems: [Ticket.Item] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack {
                    categoriesSection()
                    
                    Divider()
                    
                    ticketListItems()
                }
            }
            .navigationTitle(ticket.groceryName)
            .toolbar {
                ToolbarItem(id: "add-category-item", placement: .primaryAction) {
                    Menu {
                        ForEach(Food.Category.allCases, id: \.self) { category in
                            Button(category.title) {
                                viewModel.add(category: category)
                            }
                        }
                    } label: {
                        Image(systemName: "plus.square.on.square")
                            .rotationEffect(.degrees(90))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.pink)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func categoriesSection() -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.categories, id: \.code) { category in
                    CategoryBoxView(category: category, items: viewModel.itemsPerCategory[category] ?? []) { item in
                        Row(item: item)
                    }
                    .dropDestination(for: Ticket.Item.self) { items, location in
                        guard let droppedItem = items.first else { return false }
                        viewModel.move(item: droppedItem, to: category)
                        return true
                    }
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func ticketListItems() -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(ticket.items, id: \.name) {
                    Row(item: $0)
                        .draggable($0)
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
