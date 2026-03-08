import SwiftUI
import RealityKit

struct ContentView: View {
    @StateObject private var viewModel = ARViewModel()
    
    var body: some View {
        ZStack {
            // Layer 1: AR Camera Feed
            ARViewContainer(viewModel: viewModel)
                .ignoresSafeArea()
            
            // Layer 2: UI Overlay
            VStack {
                // Top Header
                HStack {
                    Text("ARCHILENS")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .kerning(4)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                    Spacer()
                    
                    if !viewModel.points.isEmpty {
                        Button(action: { 
                            let impact = UIImpactFeedbackGenerator(style: .soft)
                            impact.impactOccurred()
                            viewModel.clearPoints() 
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 18, weight: .bold))
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal)
                
                if let errorMessage = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(errorMessage)
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(.yellow)
                    .padding(10)
                    .background(.black.opacity(0.6))
                    .cornerRadius(8)
                    .padding(.top, 10)
                }
                
                Spacer()
                
                // Measurement Info
                VStack(spacing: 8) {
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text(viewModel.distance)
                            .font(.system(size: 84, weight: .thin, design: .rounded))
                        Text(viewModel.unit)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    if viewModel.isTargeting?.type == .estimated {
                        Text("LOW ACCURACY (POINT TRACKING)")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.orange)
                    } else {
                        Text(viewModel.points.isEmpty ? "DISTANCE TO TARGET" : "TOTAL MEASUREMENT (\(viewModel.points.count) pts)")
                            .font(.system(size: 10, weight: .black))
                            .opacity(0.6)
                    }
                }
                .foregroundColor(.white)
                .padding(.bottom, 30)
                
                // Controls
                HStack {
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        viewModel.addCurrentPoint()
                    }) {
                        Circle()
                            .fill(.white)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.black)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 10)
                    }
                    .disabled(viewModel.isTargeting == nil)
                    .opacity(viewModel.isTargeting == nil ? 0.3 : 1.0)
                }
                .padding(.bottom, 50)
            }
            
            // Layer 3: Dynamic Reticle
            ReticleView(isTargeting: viewModel.isTargeting != nil, 
                        color: viewModel.isTargeting?.type.color ?? .white)
        }
    }
}

struct ReticleView: View {
    let isTargeting: Bool
    let color: Color
    
    var body: some View {
        ZStack {
            // Outer Ring
            Circle()
                .stroke(lineWidth: 2)
                .frame(width: 32, height: 32)
                .scaleEffect(isTargeting ? 1.0 : 0.8)
            
            // Inner Dot
            Circle()
                .frame(width: 6, height: 6)
            
            // Crosshairs
            ForEach(0..<4) { i in
                Rectangle()
                    .frame(width: 2, height: 6)
                    .offset(y: -16)
                    .rotationEffect(.degrees(Double(i) * 90))
            }
        }
        .foregroundColor(color)
        .shadow(color: .black.opacity(0.5), radius: 2)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isTargeting)
    }
}

#Preview {
    ContentView()
}
