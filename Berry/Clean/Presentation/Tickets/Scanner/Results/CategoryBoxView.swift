import SwiftUI

struct CategoryBoxView<Content: View>: View {
    let category: Food.Category
    let items: [TicketDisplay.Item]
    @ViewBuilder var rowContent: (TicketDisplay.Item) -> Content
    
    init(category: Food.Category, items: [TicketDisplay.Item], rowContent: @escaping (TicketDisplay.Item) -> Content) {
        self.category = category
        self.items = items
        self.rowContent = rowContent
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(category.title)
                .foregroundStyle(category.foregroundColor)
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
                .fill(category.backgroundColor)
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
        Text(item.name)
    }
}
#endif
