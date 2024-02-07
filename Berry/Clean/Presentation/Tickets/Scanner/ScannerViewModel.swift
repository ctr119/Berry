import Foundation
import SwiftUI

@Observable
class ScannerViewModel {
    private let scanner: Ticket.Scanner
    
    init(scanner: Ticket.Scanner) {
        self.scanner = scanner
    }
    
    func generateTicket(from images: [CGImage]) async -> Ticket {
        let ticket = Ticket()
        
        for image in images {
            do {
                let items = try await scanner.items(in: image)
                ticket.add(items: items)
            } catch {
                continue
            }
        }
        
        return ticket
    }
}
