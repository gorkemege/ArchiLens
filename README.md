# ArchiLens 📐

ArchiLens is a professional iOS application that enables high-precision measurements using advanced Augmented Reality (AR) technology. Equipped with LIDAR support and sophisticated Raycasting algorithms, ArchiLens delivers stable and reliable results for various measurement needs.

## ✨ Key Features

- **Advanced Precision:** Millimeter-level accuracy powered by LIDAR mesh data and real-time geometry analysis.
- **Dynamic Measurement:** Live distance tracking between two or more points. Measurement starts the moment you place the first point.
- **Hybrid Tracking System:** 
  - 🟢 **Mesh/Geometry:** Highest precision (LIDAR-powered).
  - 🔵 **Plane Detection:** Stable measurements on detected horizontal and vertical surfaces.
  - 🟠 **Estimated Surface:** Intelligent estimation for low-texture or unmapped areas.
- **Adaptive Smoothing:** A motion-aware Low-pass Filter that eliminates jitter and ensures smooth cursor movement.
- **Visual Feedback:** A smart reticle system that changes color based on surface detection quality.
- **AR Coaching Overlay:** Integrated official Apple AR guidelines for a seamless and stable setup.

## 🛠 Technical Stack

- **Framework:** SwiftUI & RealityKit
- **Engine:** ARKit 6.0+
- **Mathematics:** High-performance SIMD-based vector calculations
- **Minimum iOS:** 15.0+

## 🚀 Getting Started

1. Open the project in Xcode.
2. Run the app on a physical iPhone or iPad (AR features are not supported on the Simulator).
3. Scan the surfaces in your environment (the Coaching Overlay will guide you).
4. When the reticle turns green or blue, tap the **"+"** button to place your first point.
5. Move the device to see the live distance and tap **"+"** again at your desired destination.

---
*Developed by Gorkem Ege*
