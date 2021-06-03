//
//  EmojiMemoryGameStore.swift
//  Memorize
//
//  Created by Marko Tadić on 6/18/20.
//  Copyright © 2020 Marko Tadić. All rights reserved.
//

import SwiftUI
import Combine

class EmojiMemoryGameStore: ObservableObject {

    let name: String

    @Published var themes: [EmojiMemoryGameTheme]

    var selectedThemeIndex: Int = -1

    var selectedTheme: EmojiMemoryGameTheme {
        themes[selectedThemeIndex]
    }

    private var autosave: AnyCancellable?

    init(name: String = "Memorize") {
        self.name = name

        let key = "EmojiMemoryGameStore.\(name)"
        if let data = UserDefaults.standard.data(forKey: key),
           let themes = try? JSONDecoder().decode([EmojiMemoryGameTheme].self, from: data) {
            self.themes = themes
        } else {
            self.themes = EmojiMemoryGameTheme.defaultThemes()
        }

        autosave = $themes.sink { themes in
            let data = try? JSONEncoder().encode(themes)
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func addTheme() {
        themes.append(.random)
    }

    func renameSelectedTheme(to newName: String) {
        themes[selectedThemeIndex].name = newName
    }

    func addEmojiToSelectedTheme(_ emoji: String) -> String {
        themes[selectedThemeIndex].emojis = (selectedTheme.emojis + emoji).uniqued()
        return selectedTheme.emojis
    }

    func removeEmojiFromSelectedTheme(_ emoji: String) -> String {
        themes[selectedThemeIndex].emojis = selectedTheme.emojis
            .filter({ !emoji.contains($0) })
        return selectedTheme.emojis
    }

    func updatePairsCountForSelectedTheme(_ count: Int) {
        themes[selectedThemeIndex].pairsCount = count
    }

    func updateColorForSelectedTheme(_ rgb: UIColor.RGB) {
        themes[selectedThemeIndex].color = rgb
    }

}

extension String {
    func uniqued() -> String {
        var uniqued = ""
        for ch in self {
            if !uniqued.contains(ch) {
                uniqued.append(ch)
            }
        }
        return uniqued
    }
}
