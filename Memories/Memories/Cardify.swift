//
//  Cardify.swift
//  Memories
//
//  Created by Gideon Boateng on 11/21/23.
//

import SwiftUI

// MARK: - Cardify Modifier
struct Cardify: AnimatableModifier {
    
    // MARK: - Initialization
    
    /// Initializes the Cardify modifier with a given face orientation.
    /// - Parameter isFaceUp: A boolean indicating whether the card is face up.
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    // MARK: - Animatable Properties
    
    /// The rotation angle of the card in degrees.
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // in degrees
    
    // MARK: - Body
    
    /// Defines the appearance and behavior of the card.
    /// - Parameter content: The content within the card.
    /// - Returns: A view representing the card.
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstant.cornerRadius)
            
            // Display different content based on the rotation angle
            if rotation < 90 {
                shape.fill().foregroundStyle(.white)
                shape.strokeBorder(lineWidth: DrawingConstant.lineWidth)
            } else {
                shape.fill()
            }
            
            // Show or hide the content based on the rotation angle
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    // MARK: - Drawing Constants
    
    private struct DrawingConstant {
        static let lineWidth: CGFloat = 3
        static let cornerRadius: CGFloat = 10
    }
}

// MARK: - View Extension

extension View {
    
    /// Applies the Cardify modifier to a view, making it appear as a card.
    /// - Parameter isFaceUp: A boolean indicating whether the card is face up.
    /// - Returns: A view modified to appear as a card.
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
