//
//  EmojiMemoryGameTheme.swift
//  Memorize
//
//  Created by Marko TadiΔ on 6/8/20.
//  Copyright Β© 2020 Marko TadiΔ. All rights reserved.
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
                emojis: "ππ΄ββ οΈπ΄π³π©π",
                pairsCount: 4,
                color: UIColor.blue.rgb
            ),
            .init(
                name: "Sports",
                emojis: "πββοΈβ½οΈππΎβ³οΈπ",
                pairsCount: 4,
                color: UIColor.red.rgb
            ),
            .init(
                name: "Halloween",
                emojis: "π»ππ·ππππΈ",
                pairsCount: 6,
                color: UIColor.orange.rgb
            ),
            .init(
                name: "Food",
                emojis: "πππ₯ππ©πππ₯",
                pairsCount: 6,
                color: UIColor.green.rgb
            ),
            .init(
                name: "Faces",
                emojis: "ππ’πππ€πππ€―π",
                pairsCount: 9,
                color: UIColor.darkGray.rgb
            ),
            .init(
                name: "Animals",
                emojis: "πΌππ¦π¦’π¦π¦π¦π¦π¦§πΈππ",
                pairsCount: 12,
                color: UIColor.brown.rgb
            ),
        ]
    }
}
