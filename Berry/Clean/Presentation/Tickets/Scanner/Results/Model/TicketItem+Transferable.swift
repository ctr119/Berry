import Foundation
import SwiftUI
import UniformTypeIdentifiers

extension Ticket.Item: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .ticketItem)
    }
}

extension UTType {
    static let ticketItem = UTType(exportedAs: "com.berry.ticketItem")
}
