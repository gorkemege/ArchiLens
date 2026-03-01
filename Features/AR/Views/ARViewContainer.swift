import SwiftUI
import RealityKit
import ARKit
import Combine

class ARViewModel: ObservableObject {
    @Published var distance: String = "--"
    @Published var isTargeting: Bool = false
    @Published var unit: String = "m"
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: ARViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        arView.session.delegate = context.coordinator
        arView.session.run(config)
        
        context.coordinator.arView = arView
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    class Coordinator: NSObject, ARSessionDelegate {
        weak var arView: ARView?
        var viewModel: ARViewModel
        
        init(viewModel: ARViewModel) {
            self.viewModel = viewModel
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            guard let arView = self.arView else { return }
            
            // Screen center (crosshair location)
            let centerPoint = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
            
            // Raycast from the center of the screen
            let results = arView.raycast(from: centerPoint, allowing: .estimatedPlane, alignment: .any)
            
            if let result = results.first {
                let targetTransform = result.worldTransform
                let targetPosition = SIMD3<Float>(targetTransform.columns.3.x,
                                                targetTransform.columns.3.y,
                                                targetTransform.columns.3.z)
                
                let cameraTransform = frame.camera.transform
                let cameraPosition = SIMD3<Float>(cameraTransform.columns.3.x,
                                                cameraTransform.columns.3.y,
                                                cameraTransform.columns.3.z)
                
                let vector = targetPosition - cameraPosition
                let distance = length(vector)
                
                DispatchQueue.main.async {
                    self.viewModel.distance = String(format: "%.2f", distance)
                    self.viewModel.isTargeting = true
                }
            } else {
                DispatchQueue.main.async {
                    self.viewModel.isTargeting = false
                    self.viewModel.distance = "--"
                }
            }
        }
    }
}
