import Foundation

struct TicketItemConverter {
    func convert(scannedItemDto: ScannedItemDTO) -> Ticket.Item {
        return .init(
            name: scannedItemDto.name,
            quantity: scannedItemDto.quantity,
            weight: scannedItemDto.weight,
            price: scannedItemDto.price,
            totalPrice: scannedItemDto.totalPrice,
            category: nil // TODO: to be done later
        )
    }
}
