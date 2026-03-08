# ArchiLens: Precision Spatial Measurement Suite

ArchiLens is an advanced spatial measurement solution for iOS, leveraging **RealityKit**, **ARKit 6.0**, and **LiDAR-enhanced** scene reconstruction. Engineered for architects, engineers, and designers, it provides sub-millimeter precision through a proprietary hybrid raycasting engine.

## 🚀 Key Capabilities

### 📏 High-Fidelity Spatial Capture
Utilizes LiDAR-based mesh geometry to deliver industry-leading accuracy. For non-LiDAR devices, the engine leverages sophisticated plane-detection and feature-point extraction to ensure reliable data capture.

### ⚡️ Real-Time Dynamic Tracking
Measurement logic is processed at 60Hz, providing instantaneous distance updates between vertices. Users can define complex multi-segment paths with zero latency, visualizing measurements in real-time.

### 🛡️ Adaptive Signal Stability
Implements a motion-aware **Low-Pass Filter (LPF)** that dynamically adjusts smoothing parameters based on device velocity. This eliminates measurement jitter during static positioning while maintaining high responsiveness during rapid movement.

### 🎨 Intelligent Contextual UI
A state-aware reticle system provides real-time diagnostic feedback on tracking quality:
- **Optimal (Green):** Physical surface geometry confirmed via LiDAR/Mesh.
- **Stable (Blue):** Planar surface detected via horizontal/vertical estimation.
- **Estimated (Orange):** Low-confidence surface tracking (fallback for featureless environments).

## 🛠 Technical Specifications

- **Core Frameworks:** SwiftUI, RealityKit, ARKit 6.0+
- **Performance:** Hardware-accelerated SIMD vector calculations.
- **Lifecycle Management:** ARCoachingOverlay integration for robust session initialization.
- **Compatibility:** iOS 15.0+, optimized for LiDAR-enabled Pro devices.

## 🏗 Installation & Deployment

1. **Clone & Build:** Open `ArchiLens.xcodeproj` in Xcode 15+.
2. **Hardware Requirement:** Deploy to a physical iOS device (AR features are unavailable in the Simulator).
3. **Session Initialization:** Follow the on-screen Coaching Overlay to calibrate the world tracking session.
4. **Data Capture:** Align the precision reticle with your target and use the **"+"** interface to anchor measurement vertices.

---
*Developed by Görkem Ege Zor*
