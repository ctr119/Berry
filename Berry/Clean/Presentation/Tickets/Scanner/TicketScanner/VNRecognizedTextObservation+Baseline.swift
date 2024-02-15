import Foundation
import Vision

extension VNRecognizedTextObservation {
    func doesBelongToTheSameBaseline(as obs: VNRecognizedTextObservation) -> Bool {
        let observationBaselineThreshold = 0.01
        
        return abs(self.boundingBox.minY - obs.boundingBox.minY) < observationBaselineThreshold
    }
}
