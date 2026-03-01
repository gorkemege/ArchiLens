# 🔍 ArchiLens

**ArchiLens** is a high-precision Augmented Reality (AR) measurement tool designed for architects, designers, and spatial enthusiasts. Built with **SwiftUI** and **RealityKit**, it provides real-time distance tracking and surface detection with a minimalist, professional interface.

![Platform](https://img.shields.io/badge/Platform-iOS%2017.0+-black?style=flat-square&logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.10-orange?style=flat-square&logo=swift)
![Framework](https://img.shields.io/badge/Framework-RealityKit-blue?style=flat-square)

---

## ✨ Key Features

- **🚀 Real-Time Measurement:** Continuous distance calculation from the camera to the physical world using advanced raycasting.
- **🎯 Dynamic Targeting:** A smart crosshair system that provides visual feedback (Target Locked) when a valid surface is detected.
- **💎 Modern Glassmorphism UI:** A clean, non-intrusive interface using Apple's `ultraThinMaterial` for a premium feel.
- **🏗️ Scene Reconstruction:** Leverages LiDAR and Scene Reconstruction (on supported devices) for enhanced spatial awareness.
- **📏 Unit Precision:** Accurate metric measurements displayed instantly on-screen.

---

## 🛠️ Tech Stack

- **UI Framework:** SwiftUI
- **AR Engine:** RealityKit
- **Tracking:** ARKit (World Tracking, Plane Detection)
- **State Management:** Combine / MVVM
- **Language:** Swift 5.10+

---

## 📂 Project Structure

```text
ArchiLens/
├── App/                # Main Entry & App Lifecycle
├── Features/
│   ├── AR/             # Core AR Logic, ViewModels & Views
│   ├── Measurement/    # Measurement History & Logic (In-Progress)
│   └── Settings/       # User Preferences (In-Progress)
├── Core/               # Utilities, Extensions & Constants
└── Resources/          # Assets, Fonts & Launch Screen
```

---

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- An iOS device with A12 Bionic chip or later (for AR features)
- iOS 17.0+

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/gorkemege/ArchiLens.git
   ```
2. Open `ArchiLens.xcodeproj` in Xcode.
3. Select your physical iPhone as the target.
4. Build and Run (**Cmd + R**).

---

## 📸 Screenshots

| Scanning | Target Locked |
| :---: | :---: |
| *Scanning for surfaces...* | *Live measurement feedback* |

*(Note: Add your actual screenshots here to showcase the app!)*

---

## 🗺️ Roadmap

- [x] Real-time center-point measurement.
- [x] Dynamic crosshair UI feedback.
- [ ] Multi-point area calculation.
- [ ] Export measurements as PDF/DXF.
- [ ] Measurement history log.
- [ ] Support for imperial units (inches/feet).

---

## 🤝 Contributing

Contributions are welcome! If you'd like to improve ArchiLens, feel free to fork the repo and create a pull request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

---

**Developed with ❤️ by [Görkem Ege Zor](https://github.com/gorkemege)**
