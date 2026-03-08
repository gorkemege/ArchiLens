import SwiftUI
import RealityKit
import ARKit
import Combine

class ARViewModel: ObservableObject {
    @Published var distance: String = "--"
    @Published var isTargeting: Bool = false
    @Published var unit: String = "m"
    @Published var errorMessage: String?
    @Published var isARAvailable: Bool = true
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
        context.coordinator.arView = arView
        
        do {
            try arView.session.run(config)
        } catch {
            let errorMessage = "AR initialization failed: \(error.localizedDescription)"
            DispatchQueue.main.async {
                self.viewModel.errorMessage = errorMessage
                self.viewModel.isARAvailable = false
            }
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    class Coordinator: NSObject, ARSessionDelegate {
        weak var arView: ARView?
        var viewModel: ARViewModel
        
        private var lastUpdateTime: CFTimeInterval = 0
        private var frameSkipCount: Int = 0
        private let frameSkipInterval: Int = 3
        private var measurementHistory: [Float] = []
        private let historySize: Int = 5
        
        init(viewModel: ARViewModel) {
            self.viewModel = viewModel
        }
        
        deinit {
            arView?.session.delegate = nil
        }
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            let errorMessage = "AR Session failed: \(error.localizedDescription)"
            DispatchQueue.main.async {
                self.viewModel.errorMessage = errorMessage
                self.viewModel.isARAvailable = false
            }
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            DispatchQueue.main.async {
                self.viewModel.isTargeting = false
                self.viewModel.distance = "--"
                self.viewModel.errorMessage = "AR Session interrupted"
            }
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            DispatchQueue.main.async {
                self.viewModel.errorMessage = nil
                self.viewModel.isARAvailable = true
            }
            
            let config = ARWorldTrackingConfiguration()
            config.planeDetection = [.horizontal, .vertical]
            config.environmentTexturing = .automatic
            
            if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
                config.sceneReconstruction = .mesh
            }
            
            do {
                try session.run(config)
            } catch {
                let errorMessage = "Failed to resume AR: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.viewModel.errorMessage = errorMessage
                }
            }
        }
        
        func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
            DispatchQueue.main.async {
                switch camera.trackingState {
                case .normal:
                    self.viewModel.errorMessage = nil
                case .notAvailable:
                    self.viewModel.errorMessage = "Camera tracking not available"
                case .limited(let reason):
                    switch reason {
                    case .insufficientFeatures:
                        self.viewModel.errorMessage = "Insufficient features detected"
                    case .excessiveMotion:
                        self.viewModel.errorMessage = "Move slower"
                    case .relocalizing:
                        self.viewModel.errorMessage = "Relocalizing..."
                    @unknown default:
                        self.viewModel.errorMessage = "Tracking limited"
                    }
                }
            }
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            frameSkipCount += 1
            if frameSkipCount < frameSkipInterval {
                return
            }
            frameSkipCount = 0
            
            guard let arView = self.arView else { return }
            guard frame.camera.trackingState == .normal else { return }
            
            let centerPoint = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
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
                var distance = length(vector)
                
                if !distance.isNaN && !distance.isInfinite && distance >= 0 {
                    distance = min(distance, 100.0)
                    
                    self.measurementHistory.append(distance)
                    if self.measurementHistory.count > self.historySize {
                        self.measurementHistory.removeFirst()
                    }
                    
                    let smoothedDistance = self.measurementHistory.reduce(0, +) / Float(self.measurementHistory.count)
                    
                    DispatchQueue.main.async {
                        self.viewModel.distance = String(format: "%.2f", smoothedDistance)
                        self.viewModel.isTargeting = true
                        self.viewModel.errorMessage = nil
                    }
                } else {
                    DispatchQueue.main.async {
                        self.viewModel.isTargeting = false
                        self.viewModel.distance = "--"
                        self.viewModel.errorMessage = "Invalid measurement"
                    }
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
