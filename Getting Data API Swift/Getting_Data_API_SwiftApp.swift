import SwiftUI

@main
struct Getting_Data_API_SwiftApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isLoading = false
                            }
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}

