import Foundation
import SwiftUI

@Observable
class ScannerViewModel {
    private let scanner: Ticket.Scanner
    
    init(scanner: Ticket.Scanner) {
        self.scanner = scanner
    }
    
    func generateTicket(from images: [CGImage]) async -> Ticket? {
        guard let image = images.first else { return nil }
        return try? await scanner.ticket(from: image)
    }
}
