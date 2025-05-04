import Foundation
import VisionKit
import Vision

struct Scanner {
    enum SError: Error {
        case failToCastObservations
        case nonSupportedGrocery
    }
    
    private let imageProcessingRepository: ImageProcessingRepository
    
    init(imageProcessingRepository: ImageProcessingRepository) {
        self.imageProcessingRepository = imageProcessingRepository
    }
    
    func scanTicket(from cgImage: CGImage) async throws -> Ticket {
        return try await imageProcessingRepository.process(image: cgImage)
    }
}
