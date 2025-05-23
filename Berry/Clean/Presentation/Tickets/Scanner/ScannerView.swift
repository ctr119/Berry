import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        
        let navigationController = UINavigationController(rootViewController: documentViewController)
        navigationController.delegate = context.coordinator
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        let scanner = Scanner(
            imageProcessingRepository: ImageProcessingRepositoryFactory.make()
        )
        let viewModel = ScannerViewModel(scanner: scanner)
        
        return Coordinator(viewModel: viewModel, parent: self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate, UINavigationControllerDelegate {
        private let viewModel: ScannerViewModel
        private let parent: ScannerView
        
        init(viewModel: ScannerViewModel,
             parent: ScannerView) {
            self.viewModel = viewModel
            self.parent = parent
        }
        
        // MARK: - VNDocumentCameraViewControllerDelegate
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            Task {
                guard let ticket = await viewModel.generateTicket(from: scan.images()) else { return }
                
                await MainActor.run {
                    let resultsView = ResultsViewFactory.make(with: ticket)
                    let hostingController = UIHostingController(rootView: resultsView)
                    controller.navigationController?.pushViewController(hostingController, animated: true)
                }
            }
            
//            DispatchQueue.global(qos: .userInitiated).async {
//                let scannedTicketModel = self.viewModel.recogniseText(from: scan.getImages())
//                
//                DispatchQueue.main.async {
//                    let rootView = NewTicketView.DI.inject(ticketModel: scannedTicketModel, cancelAction: {
//                        controller.navigationController?.dismiss(animated: true)
//                    }).toolbar(.visible, for: .navigationBar)
//                    
//                    let hostingController = UIHostingController(rootView: rootView)
//                    controller.navigationController?.pushViewController(hostingController, animated: true)
//                }
//            }
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }
        
        // MARK: - UINavigationControllerDelegate
        
        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            if viewController is VNDocumentCameraViewController, viewController.navigationController === navigationController {
                navigationController.setNavigationBarHidden(true, animated: animated)
            }
        }
    }
}

private extension VNDocumentCameraScan {
    func images() -> [CGImage] {
        var images: [CGImage] = []
        
        for pageIndex in 0..<self.pageCount {
            let image = imageOfPage(at: pageIndex)
            guard let cgImage = image.cgImage else { continue }
            images.append(cgImage)
        }
        
        return images
    }
}
