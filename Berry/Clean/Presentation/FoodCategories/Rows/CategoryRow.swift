import SwiftUI

struct CategoryRow: View {
    private let category: Food.Category
    private let onTap: () -> Void
    
    init(category: Food.Category, onTap: @escaping () -> Void) {
        self.category = category
        self.onTap = onTap
    }
    
    var body: some View {
        HStack {
            Text(category.title)
            
            Spacer()
        }
        .foregroundStyle(category.foregroundColor)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(category.backgroundColor)
        )
        .onTapGesture(perform: onTap)
    }
}

#if DEBUG
#Preview {
    CategoryRow(category: .meat) {
        // Nothing
    }
}
#endif
