import Foundation
import Vision

protocol ItemsAlgorithm {
    func process(observations: [VNRecognizedTextObservation]) -> [Ticket.Item]
}
