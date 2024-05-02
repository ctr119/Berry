import SwiftUI

struct CompactedItemRow: View {
    let item: TicketDisplay.Item
    let category: Food.Category
    
    var body: some View {
        Text(item.name)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(category.backgroundColor, lineWidth: 2)
            )
    }
}

#if DEBUG
#Preview {
    CompactedItemRow(item: .previewMock, category: .dairy)
}
#endif
