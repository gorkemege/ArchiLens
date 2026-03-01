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
                        .font(.system(size: 12, weight: .black, design: .monospaced))
                        .kerning(4)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.horizontal)
                
                Spacer()
                
                // Distance Measurement UI
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(viewModel.distance)
                        .font(.system(size: 64, weight: .light, design: .rounded))
                    Text(viewModel.unit)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.white)
                .padding(.bottom, 20)
                
                // Instructions Label
                Text(viewModel.isTargeting ? "Target Locked" : "Scanning Surfaces...")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(viewModel.isTargeting ? .green : .white)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding(.bottom, 50)
            }
            
            // Layer 3: Dynamic Center Target
            Circle()
                .stroke(viewModel.isTargeting ? Color.green : Color.white, lineWidth: 2)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .fill(viewModel.isTargeting ? Color.green : Color.white)
                        .frame(width: 4, height: 4)
                )
                .shadow(radius: 4)
        }
    }
}

#Preview {
    ContentView()
}
