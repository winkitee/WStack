//
//  WStackExamplesView.swift
//  
//
//  Created by winkitee on 2023/04/19.
//

import SwiftUI

struct WStackExamplesView: View {
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
           "🍠 Roasted Sweet Potato",
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
                                   Color.blue.opacity(0.6) :
                                   Color.secondary.opacity(0.2)
                           )
                           .cornerRadius(20)
                   }

                   WStack(Array(fruits[0...3]), spacing: 4, lineSpacing: 4, lineLimit: 2, isHiddenLastItem: true) { fruit in
                       Text(fruit)
                           .padding(.vertical, 6)
                           .padding(.horizontal, 8)
                           .background(Color.green.opacity(0.2))
                           .cornerRadius(8)
                   }

                   WStack(Array(fruits[0...3]), spacing: 4, lineSpacing: 4, lineLimit: 2, isHiddenLastItem: false) { fruit in
                       Text(fruit)
                           .padding(.vertical, 6)
                           .padding(.horizontal, 8)
                           .background(Color.green.opacity(0.2))
                           .cornerRadius(8)
                   }

                   WStack(Array(fruits[0...10]), spacing: 4, lineSpacing: 4, lineLimit: 2, isHiddenLastItem: false) { fruit in
                       Text(fruit)
                           .padding(.vertical, 6)
                           .padding(.horizontal, 8)
                           .background(Color.blue.opacity(0.2))
                           .cornerRadius(8)
                   }

                   WStack(Array(fruits[0...10]), spacing: 4, lineSpacing: 4, lineLimit: 2, isHiddenLastItem: true) { fruit in
                       Text(fruit)
                           .padding(.vertical, 6)
                           .padding(.horizontal, 8)
                           .background(Color.blue.opacity(0.2))
                           .cornerRadius(8)
                   }
               }
               .padding()
           }
       }
}

struct WStackExamplesView_Previews: PreviewProvider {
    static var previews: some View {
        WStackExamplesView()
    }
}
