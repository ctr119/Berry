import SwiftUI

extension TicketsListView {
    @Observable
    class ViewModel {
        var showScanner = false
        
        func didTapOnScannerButton() {
            showScanner = true
        }
    }
}

#if DEBUG
extension TicketsListView.ViewModel {
    static var previewMock: TicketsListView.ViewModel = .init()
}
#endif
