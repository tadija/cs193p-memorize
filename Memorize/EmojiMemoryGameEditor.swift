//
//  EmojiMemoryGameEditor.swift
//  Memorize
//
//  Created by Marko Tadić on 6/21/20.
//  Copyright © 2020 Marko Tadić. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameEditor: View {
    @EnvironmentObject var store: EmojiMemoryGameStore

    @Binding var isShowing: Bool

    @State private var name: String = ""
    @State private var emojisToAdd: String = ""
    @State private var emojis: String = ""
    @State private var pairsCount: Int = 0
    @State private var r: CGFloat = 0
    @State private var g: CGFloat = 0
    @State private var b: CGFloat = 0

    private var color: Color {
        Color(red: Double(r), green: Double(g), blue: Double(b))
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            Form {
                nameSection
                addEmojiSection
                removeEmojiSection
                cardCountSection
                colorSection
            }
        }
        .onAppear {
            let theme = self.store.selectedTheme
            self.name = theme.name
            self.emojis = theme.emojis
            self.pairsCount = theme.pairsCount
            self.r = theme.color.red
            self.g = theme.color.green
            self.b = theme.color.blue
        }
    }

    private var header: some View {
        ZStack {
            Text("Theme Editor").font(.headline).padding()
            HStack {
                Spacer()
                Button(action: {
                    self.isShowing = false
                }, label: { Text("Done") }).padding()
            }
        }
    }

    private var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Theme Name", text: $name, onEditingChanged: { began in
                if !began {
                    self.store.renameSelectedTheme(to: self.name)
                }
            })
        }
    }

    private var addEmojiSection: some View {
        Section(header: Text("Add Emoji")) {
            ZStack(alignment: .trailing) {
                TextField("Emoji", text: $emojisToAdd)
                Button(action: {
                    self.hideKeyboard()
                    self.addEmojis()
                }, label: { Text("Add") })
            }
        }
    }

    private var removeEmojiSection: some View {
        Section(header: Text("Emojis (tap to remove)")) {
            Grid(emojis.map { String($0) }, id: \.self) { emoji in
                Text(emoji).font(Font.system(size: self.fontSize))
                    .onTapGesture {
                        guard self.emojis.count > self.minimumPairsCount else {
                            return
                        }
                        self.removeEmoji(emoji)
                }
            }
            .frame(height: self.height)
        }
    }

    private var cardCountSection: some View {
        Section(header: Text("Size")) {
            if emojis.count >= minimumPairsCount {
                Stepper(
                    "\(pairsCount) Pairs",
                    value: $pairsCount,
                    in: minimumPairsCount...emojis.count,
                    step: 1
                ) { began in
                    if !began {
                        self.store.updatePairsCountForSelectedTheme(self.pairsCount)
                    }
                }
            }
        }
    }

    private var colorSection: some View {
        Section(header: Text("Color")) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(color)
                    .frame(maxWidth: 100)
                VStack {
                    Slider(
                        value: $r, in: 0...1,
                        onEditingChanged: { began in if !began { self.updateColor() } },
                        minimumValueLabel: Text("R"),
                        maximumValueLabel: Text("\(r, specifier: "%.2f")"),
                        label: { EmptyView() }
                    )
                    Slider(
                        value: $g, in: 0...1,
                        onEditingChanged: { began in if !began { self.updateColor() } },
                        minimumValueLabel: Text("G"),
                        maximumValueLabel: Text("\(g, specifier: "%.2f")"),
                        label: { EmptyView() }
                    )
                    Slider(
                        value: $b, in: 0...1,
                        onEditingChanged: { began in if !began { self.updateColor() } },
                        minimumValueLabel: Text("B"),
                        maximumValueLabel: Text("\(b, specifier: "%.2f")"),
                        label: { EmptyView() }
                    )

                }
            }
        }
    }

    // MARK: Actions

    private func addEmojis() {
        emojis = store.addEmojiToSelectedTheme(emojisToAdd)
        self.emojisToAdd = ""
    }

    private func removeEmoji(_ emoji: String) {
        self.emojis = self.store.removeEmojiFromSelectedTheme(emoji)
        if self.emojis.count < self.pairsCount {
            self.pairsCount = self.emojis.count
            self.store.updatePairsCountForSelectedTheme(self.emojis.count)
        }
    }

    private func updateColor() {
        self.store.updateColorForSelectedTheme(
            UIColor.RGB(red: r, green: g, blue: b, alpha: 1)
        )
    }

    // MARK: Constants

    private let minimumPairsCount = 2

    var height: CGFloat {
        CGFloat((emojis.count - 1) / 6) * 70 + 70
    }

    let fontSize: CGFloat = 40

}
