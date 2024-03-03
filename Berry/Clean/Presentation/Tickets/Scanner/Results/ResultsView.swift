import SwiftUI

struct ResultsView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    private let dynamicTypeSizeThreshold: DynamicTypeSize = .xxxLarge
    
    let ticket: Ticket
    let formatStyle: any FormatStyle = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            Rectangle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Rectangle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Rectangle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding()
                    }
                    
                    Divider()
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(ticket.items, id: \.name) {
                                Row(item: $0)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(ticket.groceryName)
            .toolbar {
                ToolbarItem(id: "add-category-item", placement: .primaryAction) {
                    Button(action: {}, label: {
                        Image(systemName: "plus.square.on.square")
                            .rotationEffect(.degrees(90))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.pink)
                    })
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    ResultsView(ticket: .previewMock)
}
#endif
