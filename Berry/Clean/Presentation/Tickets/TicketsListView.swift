import SwiftUI

struct TicketsListView: View {
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Empty")
            }
            .toolbar {
                Button("Scan") {
                    viewModel.didTapOnScannerButton()
                }
            }
            .sheet(isPresented: $viewModel.showScanner) {
                ScannerView()
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        
    }
}

#if DEBUG
#Preview {
    TicketsListView(viewModel: .previewMock)
}
#endif
