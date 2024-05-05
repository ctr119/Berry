import SwiftUI

struct ResultsView: View {
    @State var viewModel: ViewModel
    @State private var showCategorySheet = false
    
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
                    
                    GeometryReader { proxy in
                        ticketListItems(geometryProxy: proxy)
                    }
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
            HStack(spacing: 18) {
                ForEach(viewModel.categories, id: \.code) { category in
                    CategoryBoxView(category: category, items: viewModel.itemsPerCategory[category] ?? []) { item in
                        CompactedItemRow(item: item, category: category)
                            .draggable(item)
                    }
                    .dropDestination(for: TicketDisplay.Item.self) { items, location in
                        withAnimation {
                            guard let droppedItem = items.first else { return false }
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
    private func ticketListItems(geometryProxy: GeometryProxy) -> some View {
        ScrollView {
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible()),
                    count: geometryProxy.size.width >= 900 ? 2 : 1
                )
            ) {
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
    ResultsView(
        viewModel: .init(ticket: .previewMock)
    )
}
#endif
