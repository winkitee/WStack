# WStack

This is a view that automatically wraps lines according to the horizontal screen size.

<img src="./example.png" width="50%" height="50%">

## Usage

```swift
import SwiftUI
import WStack

struct ContentView: View {
    let fruits = [
        "🍎 Red Apple",
        "🍐 Pear",
        "🍊 Tangerine",
        "🍋 Lemon",
        "🍌 Banana",
        "🍉 Watermelon",
        "🍇 Grapes",
        "🍓 Strawberry",
        "🫐 Blueberries",
        "🍈 Melon",
        "🍒 Cherries",
        "🍑 Peach",
        "🥭 Mango",
        "🍍 Pineapple",
        "🥥 Coconut",
        "🥝 Kiwi",
        "🍅 Tomato",
        "🍆 Eggplant",
        "🥑 Avocado",
        "🫛 Pea Pod",
        "🥦 Broccoli",
        "🥬 Leafy Greens",
        "🥒 Cucumber",
        "🌶️ Hot Pepper",
        "🫑 Bell Pepper",
        "🌽 Ear of Corn",
        "🥕 Carrot",
        "🫒 Olive",
        "🧄 Garlic",
        "🧅 Onion",
        "🥔 Potato",
        "🍠 Roasted Sweet Potato"

    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                WStack(fruits, spacing: 4, lineSpacing: 4) { fruit in
                    Text(fruit)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .background(
                            fruit == "🥑 Avocado" ?
                                Color.indigo.opacity(0.6) :
                                Color.secondary.opacity(0.2)
                        )
                        .cornerRadius(20)
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```