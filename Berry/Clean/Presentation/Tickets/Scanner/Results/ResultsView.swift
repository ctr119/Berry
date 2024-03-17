import SwiftUI

struct ResultsView: View {
    @State private var viewModel: ViewModel
    
    init(ticket: Ticket) {
        viewModel = ViewModel(ticket: ticket)
    }
    
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
            .navigationTitle(viewModel.groceryName)
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
                        // TODO: Work on a new Row view for the Category Box
                    }
                    .dropDestination(for: Ticket.Item.self) { items, location in
                        withAnimation {
                            guard let droppedItem = items.first else { return false }
                            // TODO: Move from category to category
                            viewModel.move(item: droppedItem, to: category)
                            return true
                        }
                    }
                }
            }
            .padding()
            .animation(.easeInOut, value: viewModel.categories)
        }
    }
    
    @ViewBuilder
    private func ticketListItems() -> some View {
        ScrollView {
            // TODO: Change for a Grid and vary the columns based on Device
            LazyVStack(spacing: 16) {
                ForEach(viewModel.ticketItems, id: \.name) {
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
