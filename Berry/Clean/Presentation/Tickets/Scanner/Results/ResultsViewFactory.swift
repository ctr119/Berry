import Foundation

enum ResultsViewFactory {
    static func make(with ticket: TicketDisplay) -> ResultsView {
        let viewModel = ResultsView.ViewModel(ticket: ticket)
        
        return .init(viewModel: viewModel)
    }
}
