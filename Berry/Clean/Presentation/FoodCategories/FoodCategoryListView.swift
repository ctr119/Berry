import SwiftUI

struct FoodCategoryListView: View {
    let title: String
    let onTappedCategory: (Food.Category) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.headline)
            
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible()), count: 2)
                ) {
                    ForEach(Food.Category.allCases, id: \.self) { category in
                        CategoryRow(category: category) {
                            onTappedCategory(category)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding()
    }
}

#if DEBUG
#Preview {
    FoodCategoryListView(
        title: "Category List",
        onTappedCategory: { item in
            
        }
    )
}
#endif
