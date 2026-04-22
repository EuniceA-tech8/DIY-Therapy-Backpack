import SwiftUI

struct Tool: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let action: String
    let category: String
}

struct ContentView: View {
    
    let capacity = 4

    let availableTools: [Tool] = [
        Tool(emoji: "🫁", name: "Breathing", action: "Breathe in, Breathe out. Do that 5 times", category: "Calm"),
        Tool(emoji: "📓", name: "Journal", action: "Write your heart out", category: "Sad"),
        Tool(emoji: "🎧", name: "Music", action: "Listen to a music playlist that fits the mood", category: "Sad"),
        Tool(emoji: "🌿", name: "Grounding", action: "Name 5 things you can see and go for 4 more senses next", category: "Anxious"),
        Tool(emoji: "☀️", name: "Affirmation", action: "Say something kind to yourself, one is a great start", category: "Anxious")
    ]

    @State private var selectedMood = "Stressed"
        @State private var suppliesInBackpack: [Tool] = []
        @State private var currentAction: String = ""
        @State private var isFull = false

        // MARK: - Mood-based suggestions
        var suggestedTools: [Tool] {
            switch selectedMood {
            case "Stressed":
                return availableTools.filter { $0.category == "Calm" || $0.category == "Anxious" }
            case "Anxious":
                return availableTools.filter { $0.category == "Anxious" }
            case "Sad":
                return availableTools.filter { $0.category == "Sad" }
            default:
                return availableTools
            }
        }

        var body: some View {

            VStack(spacing: 20) {

                //MOOD SELECTOR
                Picker("How are you feeling?", selection: $selectedMood) {
                    Text("Stressed").tag("Stressed")
                    Text("Anxious").tag("Anxious")
                    Text("Sad").tag("Sad")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // CAPACITY DISPLAY
                Text("\(suppliesInBackpack.count) / \(capacity)")
                    .font(.headline)

                if isFull {
                    Text("Your kit is full — try using something first 💛")
                        .foregroundColor(.red)
                }

                // SUGGESTED TOOLS
                Text("Suggested for you")
                    .font(.headline)

                HStack(spacing: 20) {
                    ForEach(suggestedTools) { tool in
                        Text(tool.emoji)
                            .font(.system(size: 50))
                            .onTapGesture {

                                currentAction = tool.action

                                guard !suppliesInBackpack.contains(where: { $0.emoji == tool.emoji }) else {
                                    return
                                }

                                guard suppliesInBackpack.count < capacity else {
                                    isFull = true
                                    return
                                }

                                suppliesInBackpack.append(tool)
                                isFull = suppliesInBackpack.count >= capacity
                            }
                    }
                }

                // ACTION DISPLAY
                if !currentAction.isEmpty {
                    Text(currentAction)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .multilineTextAlignment(.center)
                        .font(.headline)
                }

                // BACKPACK VISUAL
                ZStack {
                    Image(systemName: "backpack")
                        .resizable()
                        .frame(width: 200, height: 250)
                        .foregroundColor(isFull ? .red : suppliesInBackpack.count >= 2 ? .blue : .brown)

                    VStack(spacing: 8) {
                        ForEach(suppliesInBackpack) { tool in
                            Text(tool.emoji)
                                .font(.largeTitle)
                                .onTapGesture {
                                    // remove item on tap
                                    suppliesInBackpack.removeAll { $0.id == tool.id }
                                    isFull = false
                                }
                        }
                    }
                }

                      //EMPTY BUTTON
                      Button("Empty Backpack") {
                          suppliesInBackpack.removeAll()
                          currentAction = "Your kit is empty. Add something helpful 💛"
                          isFull = false
                      }
                      .padding()
                      .background(Color.red)
                      .foregroundColor(.white)
                      .cornerRadius(10)
                  }
                  .padding()
              }
          }

#Preview {
    ContentView()
}
