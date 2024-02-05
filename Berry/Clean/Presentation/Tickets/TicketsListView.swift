import SwiftUI

struct TicketsListView: View {
    @State private var shouldOpenScanner = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Empty")
            }
            .toolbar {
                Button("Scan") {
                    shouldOpenScanner = true
                }
            }
            .sheet(isPresented: $shouldOpenScanner, onDismiss: {
                shouldOpenScanner = false
            }) {
                Text("Hello")
    //            ScannerView()
    //                .edgesIgnoringSafeArea(.bottom)
            }
        }
        
    }
}

#Preview {
    TicketsListView()
}
