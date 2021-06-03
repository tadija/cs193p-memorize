//
//  EmojiMemoryGameList.swift
//  Memorize
//
//  Created by Marko Tadić on 6/18/20.
//  Copyright © 2020 Marko Tadić. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameList: View {
    @EnvironmentObject var store: EmojiMemoryGameStore

    @State private var showEditor = false
    @State private var editMode: EditMode = .inactive

    private var isEditing: Bool {
        editMode.isEditing && editMode != .transient
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    self.listItem(for: theme)
                }
                .onDelete(perform: deleteItem)
                .onMove(perform: moveItem)
            }
            .navigationBarTitle(store.name)
            .navigationBarItems(
                leading: addButton,
                trailing: EditButton()
                    .padding([.leading, .top, .bottom])
            )
            .sheet(isPresented: $showEditor) {
                EmojiMemoryGameEditor(isShowing: self.$showEditor)
                    .environmentObject(self.store)
            }
            .environment(\.editMode, $editMode)
        }
    }

    private func listItem(for theme: EmojiMemoryGameTheme) -> some View {
        HStack(spacing: 16) {
            if isEditing {
                Image(systemName: "pencil.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color(theme.color))
                    .onTapGesture {
                        if let index = self.store.themes.firstIndex(matching: theme) {
                            self.store.selectedThemeIndex = index
                            self.showEditor = true
                        }
                }
            }

            themeView(for: theme)

            if !isEditing {
                NavigationLink(
                    destination: EmojiMemoryGameView(theme)
                        .navigationBarTitle(theme.name),
                    label: { EmptyView() }
                ).frame(maxWidth: 0)
                Spacer()
                Image(systemName: "chevron.right")
                    .imageScale(.small)
            }
        }
    }

    private func themeView(for theme: EmojiMemoryGameTheme) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .font(.largeTitle)
                .foregroundColor(
                    isEditing ? Color(.label) : Color(theme.color)
            )
            Text(self.subtitle(for: theme))
                .font(.footnote)
                .lineLimit(1)
        }
    }

    private func subtitle(for theme: EmojiMemoryGameTheme) -> String {
        let emojis = theme.emojis
        let pairsCount = theme.pairsCount
        if emojis.count == pairsCount {
            return "All of \(emojis)"
        } else {
            return "\(pairsCount) pairs from \(emojis)"
        }
    }

    private var addButton: some View {
        Button(action: addItem, label: {
            Image(systemName: "plus").imageScale(.large)
                .padding([.top, .bottom, .trailing])
        })
    }

    // MARK: Actions

    private func addItem() {
        withAnimation {
            self.store.addTheme()
        }
    }

    private func deleteItem(indexSet: IndexSet) {
        withAnimation {
            self.store.themes.remove(atOffsets: indexSet)
        }
    }

    func moveItem(from source: IndexSet, to destination: Int) {
        withAnimation {
            self.store.themes.move(fromOffsets: source, toOffset: destination)
        }
    }

}

struct EmojiMemoryGameList_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameList()
    }
}
