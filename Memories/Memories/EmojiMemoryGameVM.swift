//
//  EmojiMemoryGameVM.swift
//  Memories
//
//  Created by Gideon Boateng on 11/15/23.
//
// The gatekeeper between the View and the Model
// It imports a SwiftUI
// It doesn't create Views or anything of that sort
// Contains UI dependant --> Color, Images
import SwiftUI

// MARK: - Emoji Memory Game View Model

/// A ViewModel class for the Emoji Memory Game.
class EmojiMemoryGameVM: ObservableObject {
    
    // MARK: - Type Aliases
    
    /// Represents a card in the Emoji Memory Game.
    typealias Card = EmojiMemoryGameModel<String>.Card
    
    // MARK: - Static Properties
    
    /// An array of emojis to be used in the game.
    static let emojis = ["😮","👨‍🦳","👻","🤡","👿","🧑‍💻","🌕","😶‍🌫️","🥋","🤴",
                         "🐼","🎩","🙉","🐷","🦅","🐅","⚙️","🧻","💎","🕰️",
                         "💰","🏠","🏆","🎾"]
    
    // MARK: - Static Methods
    
    /// Creates and returns an instance of the Emoji Memory Game.
    static func createMemoryGame() -> EmojiMemoryGameModel<String> {
        EmojiMemoryGameModel<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    // MARK: - Published Properties
    
    /// The Emoji Memory Game model.
    @Published private var model = createMemoryGame()
    
    // MARK: - Computed Properties
    
    /// The array of cards in the Emoji Memory Game.
    var cards: Array<Card> {
        model.cards
    }
    
    // MARK: - Intents
    
    // MARK: Card Selection Intent
    
    /// Chooses a card in the Emoji Memory Game.
    /// - Parameter card: The selected card.
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    // MARK: Shuffle Intent
    
    /// Shuffles the cards in the Emoji Memory Game.
    func shuffle() {
        model.shuffle()
    }
    
    // MARK: Restart Intent
    
    /// Restarts the Emoji Memory Game by creating a new game model.
    func restart() {
        model = EmojiMemoryGameVM.createMemoryGame()
    }
}
