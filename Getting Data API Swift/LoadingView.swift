import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.95, blue: 0.9),
                         Color(red: 1.0, green: 0.85, blue: 0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)

            VStack {
                Text("🐱 Loading Cat Facts...")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.7, green: 0.3, blue: 0.4))
                    .padding()

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.pink))
                    .scaleEffect(2)
            }
        }
    }
}

