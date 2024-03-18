import SwiftUI

struct CategoryBoxView<Content: View>: View {
    let category: Food.Category
    let items: [Ticket.Item]
    @ViewBuilder var rowContent: (Ticket.Item) -> Content
    
    init(category: Food.Category, items: [Ticket.Item], rowContent: @escaping (Ticket.Item) -> Content) {
        self.category = category
        self.items = items
        self.rowContent = rowContent
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(category.title)
                .foregroundStyle(.white)
                .padding(.top, 10)
            
            VStack {
                if items.isEmpty {
                    emptyMessageView
                } else {
                    itemsList
                }
            }
            .frame(minWidth: 150)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray)
        )
    }
    
    private var emptyMessageView: some View {
        Text("Drag items here to assign them a category")
            .italic()
            .foregroundStyle(Color.gray)
            .frame(maxWidth: 150, maxHeight: .infinity)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private var itemsList: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(items, id: \.name) { item in
                    rowContent(item)
                }
            }
            .padding()
        }
    }
}

#if DEBUG
#Preview {
    CategoryBoxView(category: .other, items: []) { item in
        ResultsView.Row(item: item)
    }
}
#endif
