//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Marko Tadić on 5/21/20.
//  Copyright © 2020 Marko Tadić. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {

    @Published private var model: MemoryGame<String>

    private let theme: EmojiMemoryGameTheme

    init(_ theme: EmojiMemoryGameTheme) {
        self.model = Self.createMemoryGame(theme)
        self.theme = theme
    }

    private static func createMemoryGame(_ theme: EmojiMemoryGameTheme) -> MemoryGame<String> {
        let pairs = Array(theme.emojis.shuffled().prefix(theme.pairsCount))
        return MemoryGame<String>(numberOfPairsOfCards: pairs.count) { pairIndex in
            return String(pairs[pairIndex])
        }
    }

    // MARK: Access to the Model

    var cards: [MemoryGame<String>.Card] {
        model.cards
    }

    var score: Int {
        model.score
    }

    var name: String {
        theme.name
    }

    var color: Color {
        Color(theme.color)
    }

    // MARK: Intents

    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }

    func resetGame() {
        model = Self.createMemoryGame(theme)
    }

}

extension Data {
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
