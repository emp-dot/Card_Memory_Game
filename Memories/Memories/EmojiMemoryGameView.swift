//
//  ContentView.swift
//  Memories
//
//  Created by Gideon Boateng on 11/15/23.
//

// The view --> ViewModel
import SwiftUI

struct EmojiMemoryGameView: View {
    // Connecting the view ---> VM
    @ObservedObject var gameVM: EmojiMemoryGameVM
    @Namespace private var dealingNamespace
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom){
            VStack {
                gameBody
                HStack
                {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    
    // MARK: - Deal Animation
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGameVM.Card)
    {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGameVM.Card) -> Bool
    {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGameVM.Card) -> Animation
    {
        var delay = 0.0
        if let index = gameVM.cards.firstIndex(where: { $0.id == card.id}) {
            delay = Double(index) * (CardContent.totalDealDuration / Double(gameVM.cards.count))
        }
        return Animation.easeInOut(duration: CardContent.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGameVM.Card) -> Double
    {
        -Double(gameVM.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    // MARK: - Game Body
    var gameBody: some  View {
        AspectVGrid (items: gameVM.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp)
            {
                Color.clear
            } else
            {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture
                {
                    // calling the intent to choose the card
                    withAnimation {
                        gameVM.choose(card)
                    }
                }
            }
        }
        .foregroundColor(.red)
    }
    
    // MARK: - Deck Body
    var deckBody: some View
    {
        ZStack
        {
            ForEach (gameVM.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: CardContent.undealtWidth, height: CardContent.undealtHeight)
        .foregroundColor(CardContent.color)
        .onTapGesture {
            // *deal* cards
            for card in gameVM.cards {
                withAnimation(dealAnimation(for: card))
                {
                    deal(card)
                }
            }
        }
    }
    
    // MARK: - Shuffle Button
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                // Calling the intent to shuffle the cards
                gameVM.shuffle()
            }
        }
    }
    
    // MARK: - Restart Button
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                // Calling the intent to restart the cards
                gameVM.restart()
            }
        }
    }
    
    // MARK: - Card Content
    private struct CardContent
    {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: EmojiMemoryGameVM.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation (.linear(duration: card.bonusRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                .padding(5)
                .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .padding(5)
                    .font(Font.system(size: DrawingConstant.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }.cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    // MARK: - Scale Calculation
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstant.fontSize/DrawingConstant.fontScale)
    }
    
    // MARK: - Font Calculation
    private func font (in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstant.fontScale)
    }
    
    // MARK: - Drawing Constants
    private struct DrawingConstant {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGameVM()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(gameVM: game)
    }
}
