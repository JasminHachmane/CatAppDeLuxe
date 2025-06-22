import SwiftUI

struct FactListView: View {
    let title: String
    @State var facts: [String]
    
    @State private var showingShareSheet = false
    @State private var shareText = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.95, blue: 0.9),
                         Color(red: 1.0, green: 0.85, blue: 0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(Color(red: 0.7, green: 0.3, blue: 0.4))
                    .padding([.top, .horizontal])
                
                if facts.isEmpty {
                    Spacer()
                    Text("No facts yet 😿")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(facts, id: \.self) { fact in
                                HStack {
                                    Text("🐾 " + fact)
                                        .padding()
                                        .background(Color.white.opacity(0.85))
                                        .cornerRadius(16)
                                        .shadow(color: .pink.opacity(0.3), radius: 6, x: 0, y: 4)
                                        .foregroundColor(Color(red: 0.5, green: 0.2, blue: 0.3))
                                        .font(.body)
                                    
                                    Spacer()
                                    
                                    // Deel-knop
                                    Button(action: {
                                        shareText = fact
                                        showingShareSheet = true
                                    }) {
                                        Image(systemName: "square.and.arrow.up")
                                            .foregroundColor(.blue)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    
                                    // Verwijder-knop
                                    Button(action: {
                                        deleteFact(fact)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                                .padding(.horizontal)
                            }
                            .onDelete(perform: deleteFacts)
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !facts.isEmpty {
                    Button("Clear All") {
                        facts.removeAll()
                    }
                    .foregroundColor(.red)
                }
            }
        }
        // Share Sheet
        .sheet(isPresented: $showingShareSheet) {
            ActivityView(activityItems: [shareText])
        }
    }
    
    func deleteFact(_ fact: String) {
        facts.removeAll(where: { $0 == fact })
    }
    
    func deleteFacts(at offsets: IndexSet) {
        facts.remove(atOffsets: offsets)
    }
}

// UIKit wrapper voor share sheet
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

