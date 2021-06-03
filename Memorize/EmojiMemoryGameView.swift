//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Marko Tadić on 5/21/20.
//  Copyright © 2020 Marko Tadić. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    init(_ viewModel: EmojiMemoryGame) {
        self.viewModel = viewModel
    }

    init(_ theme: EmojiMemoryGameTheme) {
        viewModel = EmojiMemoryGame(theme)
    }

    var body: some View {
        VStack {
            Grid(viewModel.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        withAnimation(.linear) {
                            self.viewModel.choose(card: card)
                        }
                }
                .padding(5)
            }
            .padding()
            Text("Score: \(viewModel.score)")
                .font(.largeTitle).bold()
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .foregroundColor(viewModel.color)
        .navigationBarItems(trailing: newGame)
    }

    private var newGame: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                self.viewModel.resetGame()
            }
        }, label: { Text("New Game") })
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card

    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }

    @State private var animatedBonusRemaining: Double = 0

    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }

    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(
                            startAngle: Angle.degrees(0-90),
                            endAngle: Angle.degrees(-animatedBonusRemaining*360-90),
                            clockwise: true
                        )
                            .onAppear {
                                self.startBonusTimeAnimation()
                        }
                    } else {
                        Pie(
                            startAngle: Angle.degrees(0-90),
                            endAngle: Angle.degrees(-card.bonusRemaining*360-90),
                            clockwise: true
                        )
                    }
                }
                .padding(5)
                .opacity(0.4)
                .transition(.identity)
                Text(self.card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle(degrees: card.isMatched ? 360: 0))
                    .animation(
                        card.isMatched ?
                            Animation.linear(duration: 1)
                                .repeatForever(autoreverses: false) :
                            .default
                )

            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(.scale)
        }
    }

    // MARK: Constants

    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame(.random)
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(game)
    }
}
