import SwiftUI
import RealityKit
import ARKit
import Combine
import simd

class ARViewModel: ObservableObject {
    @Published var distance: String = "0.00"
    @Published var isTargeting: HitResult? = nil
    @Published var unit: String = "m"
    @Published var errorMessage: String?
    @Published var isARAvailable: Bool = true
    @Published var points: [SIMD3<Float>] = []
    @Published var totalDistance: Float = 0.0
    
    struct HitResult {
        let position: SIMD3<Float>
        let normal: SIMD3<Float>
        let type: ResultType
        
        enum ResultType {
            case mesh, plane, estimated
            
            var color: Color {
                switch self {
                case .mesh: return .green
                case .plane: return .blue
                case .estimated: return .orange
                }
            }
        }
    }
    
    func addCurrentPoint() {
        if let target = isTargeting {
            points.append(target.position)
            updateTotalDistance()
        }
    }
    
    func clearPoints() {
        points.removeAll()
        totalDistance = 0.0
        distance = "0.00"
    }
    
    // Live update for the UI distance label
    func updateLiveDistance(currentPos: SIMD3<Float>, cameraPos: SIMD3<Float>) {
        if points.isEmpty {
            // No points yet: Show distance from camera to target
            let dist = simd_distance(currentPos, cameraPos)
            distance = String(format: "%.2f", dist)
        } else {
            // Has points: Show path distance + distance from last point to target
            var pathDist: Float = 0.0
            for i in 0..<points.count - 1 {
                pathDist += simd_distance(points[i], points[i+1])
            }
            let liveDist = simd_distance(points.last!, currentPos)
            totalDistance = pathDist + liveDist
            distance = String(format: "%.2f", totalDistance)
        }
    }
    
    private func updateTotalDistance() {
        var dist: Float = 0.0
        guard points.count >= 2 else {
            totalDistance = 0.0
            return
        }
        for i in 0..<points.count - 1 {
            dist += simd_distance(points[i], points[i+1])
        }
        totalDistance = dist
    }
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
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .anyPlane
        arView.addSubview(coachingOverlay)
        
        arView.session.run(config)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    class Coordinator: NSObject, ARSessionDelegate {
        weak var arView: ARView?
        var viewModel: ARViewModel
        
        private var lastPosition: SIMD3<Float>?
        private let smoothingFactor: Float = 0.15
        
        init(viewModel: ARViewModel) {
            self.viewModel = viewModel
        }
        
        deinit {
            arView?.session.delegate = nil
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            guard let arView = self.arView else { return }
            let centerPoint = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
            
            // PRIORITY-BASED ACCURATE RAYCASTING
            func performRaycast() -> (SIMD3<Float>, SIMD3<Float>, ARViewModel.HitResult.ResultType)? {
                // 1. Mesh/Geometry (Millimeter Precision - Best for LIDAR/Detected Planes)
                if let result = arView.raycast(from: centerPoint, allowing: .existingPlaneGeometry, alignment: .any).first {
                    return (
                        SIMD3<Float>(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z),
                        SIMD3<Float>(result.worldTransform.columns.2.x, result.worldTransform.columns.2.y, result.worldTransform.columns.2.z),
                        .mesh
                    )
                }
                
                // 2. Fallback: Estimated Surface (Calculated from feature points)
                if let result = arView.raycast(from: centerPoint, allowing: .estimatedPlane, alignment: .any).first {
                    return (
                        SIMD3<Float>(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z),
                        SIMD3<Float>(0, 1, 0),
                        .estimated
                    )
                }
                return nil
            }
            
            if let (pos, normal, type) = performRaycast() {
                let smoothedPos: SIMD3<Float>
                if let last = lastPosition {
                    let movement = simd_distance(pos, last)
                    // If moving too far (tracking jump), snap instead of smooth
                    let adaptiveSmoothing = movement > 0.5 ? 1.0 : (movement > 0.05 ? 0.4 : smoothingFactor)
                    smoothedPos = mix(last, pos, t: adaptiveSmoothing)
                } else {
                    smoothedPos = pos
                }
                lastPosition = smoothedPos
                
                let cameraPos = SIMD3<Float>(frame.camera.transform.columns.3.x,
                                           frame.camera.transform.columns.3.y,
                                           frame.camera.transform.columns.3.z)
                
                DispatchQueue.main.async {
                    self.viewModel.isTargeting = ARViewModel.HitResult(
                        position: smoothedPos,
                        normal: normal,
                        type: type
                    )
                    // Update live distance
                    self.viewModel.updateLiveDistance(currentPos: smoothedPos, cameraPos: cameraPos)
                }
            } else {
                DispatchQueue.main.async {
                    self.viewModel.isTargeting = nil
                }
            }
        }
        
        func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
            DispatchQueue.main.async {
                switch camera.trackingState {
                case .normal: self.viewModel.errorMessage = nil
                case .notAvailable: self.viewModel.errorMessage = "Camera not available"
                case .limited(let reason):
                    switch reason {
                    case .insufficientFeatures: self.viewModel.errorMessage = "Too plain or dark"
                    case .excessiveMotion: self.viewModel.errorMessage = "Move slower"
                    case .relocalizing: self.viewModel.errorMessage = "Relocalizing..."
                    case .initializing: self.viewModel.errorMessage = "Initializing..."
                    @unknown default: self.viewModel.errorMessage = "Limited tracking"
                    }
                @unknown default: break
                }
            }
        }
    }
}
