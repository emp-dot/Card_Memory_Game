//
//  MemoriesApp.swift
//  Memories
//
//  Created by Gideon Boateng on 11/15/23.
//

import SwiftUI

@main
struct MemoriesApp: App {
    private let game = EmojiMemoryGameVM ()
    
    var body: some Scene {
        WindowGroup {
            // pass it here
            EmojiMemoryGameView(gameVM: game)
        }
    }
}
