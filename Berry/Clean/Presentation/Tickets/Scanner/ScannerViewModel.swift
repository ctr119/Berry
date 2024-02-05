import Foundation
import SwiftUI

@Observable
class ScannerViewModel {
    private let recognizer: TicketItems.Recognizer
    
    init(recognizer: TicketItems.Recognizer) {
        self.recognizer = recognizer
    }
    
    func generateTicket(from images: [CGImage]) async -> Ticket {
        let ticket = Ticket()
        
        for image in images {
            do {
                let items = try await recognizer.items(in: image)
                ticket.add(items: items)
            } catch {
                continue
            }
        }
        
        return ticket
    }
}
