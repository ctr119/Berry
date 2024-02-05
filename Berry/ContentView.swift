import SwiftUI

struct ContentView: View {
    var body: some View {
        TicketsListView.Factory.make()
    }
}

#Preview {
    ContentView()
}
