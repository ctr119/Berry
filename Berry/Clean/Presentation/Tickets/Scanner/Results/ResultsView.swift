import SwiftUI

struct ResultsView: View {
    @State private var showCategorySheet = false
    @State private var viewModel: ViewModel
    
    init(ticket: Ticket) {
        viewModel = ViewModel(ticket: ticket)
    }
    
    var body: some View {
        NavigationStack {
            /// TODO: If the width of the Boxes is not ideal,
            /// embed the ZStack into a Geometry Reader and
            /// pass the proxy to calculate a proper size
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
                    Button(action: {
                        showCategorySheet = true
                    }, label: {
                        Image(systemName: "plus.square.on.square")
                            .rotationEffect(.degrees(90))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.pink)
                    })
                }
            }
            .sheet(isPresented: $showCategorySheet) {
                FoodCategoryListView(
                    title: "Add a category...",
                    onTappedCategory: { category in
                        viewModel.add(category: category)
                        showCategorySheet = false
                    }
                )
                .padding(.top, 15)
                .presentationDetents([.medium, .fraction(0.85)])
                .presentationDragIndicator(.visible)
                .ignoresSafeArea(.container, edges: .bottom)
            }
        }
    }
    
    @ViewBuilder
    private func categoriesSection() -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.categories, id: \.code) { category in
                    CategoryBoxView(category: category, items: viewModel.itemsPerCategory[category] ?? []) { item in
                        CompactedItemRow(item: item, category: category)
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
                    DetailedItemRow(item: $0)
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
