//
//  MemorizeGameModel.swift
//  Memories
//
//  Created by Gideon Boateng on 11/15/23.
//


// This is our Swift Model -- UI Independent
// The model ---> ViewModel
import Foundation


// MARK: - Emoji Memory Game Model

/// A model representing the Emoji Memory Game.
struct EmojiMemoryGameModel<CardContent> where CardContent: Equatable{
    
    // MARK: - Properties
    
    /// An array of cards in the game.
    private(set) var cards: Array<Card>
    
    // MARK: - Computed Properties
    
    /// The index of the currently faced-up card.
    private var indexOfOneFacedUp: Int? {
        get {
            cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly
        }
        set {
            cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) }
        }
    }
    
    // MARK: - Intent: Choose a Card
    
    /// Chooses a card in the Emoji Memory Game.
    /// - Parameter card: The selected card.
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfOneFacedUp {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfOneFacedUp = chosenIndex
            }
        }
    }
    
    // MARK: - Intent: Shuffle Cards
    
    /// Shuffles the cards in the Emoji Memory Game.
    mutating func shuffle() {
        cards.shuffle()
    }
    
    // MARK: - Initialization
    
    /// Initializes the Emoji Memory Game with a given number of pairs of cards.
    /// - Parameters:
    ///   - numberOfPairsOfCards: The number of pairs of cards to create.
    ///   - createCardContent: A closure to create the content for each card.
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        
        cards.shuffle()
    }
    
    // MARK: - Card Structure
    
    /// A structure representing a card in the Emoji Memory Game.
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        let id: Int
        
        // MARK: - Bonus Time Properties
        
        var bonusTimeLimit: TimeInterval = 6
        var lastFaceUpDate: Date?
        var pastFaceUpTime: TimeInterval = 0
        
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // MARK: - Bonus Time Methods
        
        mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

// MARK: - Array Extension

extension Array {
    
    /// A computed property that returns the element if the array contains exactly one element; otherwise, returns `nil`.
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
