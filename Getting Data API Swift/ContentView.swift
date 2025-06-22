import SwiftUI
import AVFoundation

struct CatFact: Decodable, Hashable {
    let fact: String
}

struct ContentView: View {
    @State private var currentFact: String = "Fetching a fun fact... 🐱"
    @State private var allFacts: [String] = []
    @State private var favorites: [String] = []
    @State private var fadeIn = false
    @State private var isLoading = false
    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        NavigationStack {
            ZStack {
                // Mooie zachte pastel achtergrond
                LinearGradient(
                    colors: [Color(red: 1.0, green: 0.95, blue: 0.9),
                             Color(red: 1.0, green: 0.85, blue: 0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 40) {
                    // Titel met kat-emoji en leuk lettertype
                    Text("🐾 Cat Facts Deluxe 🐱")
                        .font(.system(size: 33, weight: .black, design: .rounded))
                        .foregroundColor(Color(red: 0.7, green: 0.3, blue: 0.4))
                        .shadow(color: .pink.opacity(0.6), radius: 5, x: 2, y: 2)
                        .padding(.top)
                    
                    VStack(spacing: 24) {
                        Text(currentFact)
                            .font(.title3)
                            .foregroundColor(Color(red: 0.5, green: 0.2, blue: 0.3))
                            .padding(24)
                            .multilineTextAlignment(.center)
                            .background(Color.white.opacity(0.85))
                            .cornerRadius(20)
                            .shadow(color: .pink.opacity(0.3), radius: 10, x: 0, y: 5)
                            .opacity(fadeIn ? 1 : 0)
                            .animation(.easeIn(duration: 0.6), value: fadeIn)
                            .padding(.horizontal)
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                Task { await loadNewFact() }
                            }) {
                                Label("New", systemImage: "arrow.clockwise")
                                    .font(.headline)
                                    .padding()
                                    .frame(minWidth: 80)
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }

                            Button(action: saveToFavorites) {
                                Label("Favorite", systemImage: "heart.fill")
                                    .font(.headline)
                                    .padding()
                                    .frame(minWidth: 100)
                                    .background(Color.pink.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }

                            Button(action: {
                                speak(text: currentFact)
                            }) {
                                Label("Speak", systemImage: "speaker.wave.2.fill")
                                    .font(.headline)
                                    .padding()
                                    .frame(minWidth: 80)
                                    .background(Color.green.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding(.horizontal)

                    VStack(spacing: 20) {
                        NavigationLink(destination: FactListView(title: "⭐ Favorites", facts: favorites)) {
                            Label("Favorites", systemImage: "star.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.pink.opacity(0.3))
                                .cornerRadius(15)
                                .foregroundColor(Color(red: 0.7, green: 0.2, blue: 0.3))
                                .font(.headline)
                        }

                        NavigationLink(destination: FactListView(title: "📜 Viewed Facts", facts: allFacts)) {
                            Label("Viewed", systemImage: "doc.text.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.3))
                                .cornerRadius(15)
                                .foregroundColor(Color.blue)
                                .font(.headline)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.bottom, 40)
            }
            .task { await loadNewFact() }
        }
    }

    func loadNewFact() async {
        guard let url = URL(string: "https://catfact.ninja/fact") else { return }
        isLoading = true
        fadeIn = false

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(CatFact.self, from: data)

            await MainActor.run {
                currentFact = decoded.fact + " 🐾"
                if !allFacts.contains(decoded.fact) {
                    allFacts.insert(decoded.fact, at: 0)
                }
                fadeIn = true
                isLoading = false
            }
        } catch {
            await MainActor.run {
                currentFact = "Oops! Could not fetch a fact 😿"
                isLoading = false
            }
        }
    }

    func saveToFavorites() {
        guard !favorites.contains(currentFact) else { return }
        favorites.insert(currentFact, at: 0)
    }

    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
}

#Preview {
    ContentView()
}

