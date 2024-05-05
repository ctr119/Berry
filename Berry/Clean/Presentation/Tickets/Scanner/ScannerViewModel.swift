import Foundation
import SwiftUI

@Observable
class ScannerViewModel {
    private let scanner: Scanner
    
    init(scanner: Scanner) {
        self.scanner = scanner
    }
    
    func generateTicket(from images: [CGImage]) async -> TicketDisplay? {
        guard let image = images.first else { return nil }
        let ticket = try? await scanner.scanTicket(from: image)
        
        // TODO: Convert to TicketDisplay
        return nil
    }
}
