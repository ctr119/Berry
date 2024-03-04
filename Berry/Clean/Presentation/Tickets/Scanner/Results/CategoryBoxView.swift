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
            Text(category.title.uppercased())
                .foregroundStyle(.white)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(items, id: \.name) { item in
                        rowContent(item)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                    }
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            .padding()
        }
        .background(Color.gray)
    }
}

#if DEBUG
#Preview {
    CategoryBoxView(category: .other, items: [.previewMock, .previewMock]) { item in
        ResultsView.Row(item: item)
    }
}
#endif
