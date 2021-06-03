//
//  EmojiMemoryGameTheme.swift
//  Memorize
//
//  Created by Marko Tadić on 6/8/20.
//  Copyright © 2020 Marko Tadić. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameTheme: Codable, Identifiable {
    private(set) var id: String = UUID().uuidString

    var name: String
    var emojis: String
    var pairsCount: Int
    var color: UIColor.RGB

    static var random: Self {
        Self.defaultThemes().randomElement()!
    }

    static func defaultThemes() -> [Self] {
        [
            .init(
                name: "Flags",
                emojis: "🏁🏴‍☠️🏴🏳🚩🎌",
                pairsCount: 4,
                color: UIColor.blue.rgb
            ),
            .init(
                name: "Sports",
                emojis: "🏄‍♀️⚽️🏀🎾⛳️🏈",
                pairsCount: 4,
                color: UIColor.red.rgb
            ),
            .init(
                name: "Halloween",
                emojis: "👻🎃🕷💀😈🙀🕸",
                pairsCount: 6,
                color: UIColor.orange.rgb
            ),
            .init(
                name: "Food",
                emojis: "🍔🍟🥐🍗🍩🍉🍕🥑",
                pairsCount: 6,
                color: UIColor.green.rgb
            ),
            .init(
                name: "Faces",
                emojis: "😀😢😉😃🤓😎😇🤯🙃",
                pairsCount: 9,
                color: UIColor.darkGray.rgb
            ),
            .init(
                name: "Animals",
                emojis: "🐼🐔🦄🦢🦞🦚🦘🦜🦧😸🐊🐍",
                pairsCount: 12,
                color: UIColor.brown.rgb
            ),
        ]
    }
}
