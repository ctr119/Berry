import Foundation

struct TicketItemConverter {
    func convert(scannedItemDto: ScannedItemDTO, category: String) -> Ticket.Item {
        return .init(
            name: scannedItemDto.name,
            quantity: scannedItemDto.quantity,
            weight: scannedItemDto.weight,
            price: scannedItemDto.price,
            totalPrice: scannedItemDto.totalPrice,
            category: category
        )
    }
}
