import SwiftUI
import SwiftData

@main
struct BerryApp: App {
    let container: ModelContainer = DatabaseContainerFactory.make()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            ResultsView(viewModel: .init(ticket: .previewMock))
        }
        .modelContainer(container)
    }
}
