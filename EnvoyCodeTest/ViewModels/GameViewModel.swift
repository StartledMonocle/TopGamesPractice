//
//  GameViewModel.swift
//  EnvoyCodeTest
//
//  Created by Long Le on 2/25/19.
//  Copyright © 2019 Envoy. All rights reserved.
//

import Foundation

public class GameViewModel {
    
    private let game: Game
    
    public init(game: Game) {
        
        self.game = game
    }
    
    public var name: String {
        
        return game.name
    }
    
    public var imageURL: URL? {
        
        return game.imageURL
    }
    
    public var viewerCountText: String {
        
        return "\(game.viewerCount) viewers"
    }
}
