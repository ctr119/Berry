import Foundation
import SwiftUI

@Observable
class ScannerViewModel {
    private let scanner: Scanner
    
    init(scanner: Scanner) {
        self.scanner = scanner
    }
    
    func generateTicket(from images: [CGImage]) async -> TicketDisplay? {
        guard let image = images.first,
              let ticket = try? await scanner.scanTicket(from: image) else { return nil }
        
        // TODO: Add `category` to the parsing process
        return ticket.toDisplay
    }
}
