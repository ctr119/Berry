import Foundation

extension TicketsListView {
    enum Factory {
        static func make() -> TicketsListView {
            .init(viewModel: .init())
        }
    }
}
