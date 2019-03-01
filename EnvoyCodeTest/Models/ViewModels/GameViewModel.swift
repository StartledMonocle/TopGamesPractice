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
    
    public var name: String? {
        
        if let name = game.name {
        
            return name
        }
        else {
            
            return nil
        }
    }
    
    public var imageURL: URL? {
        
        if let imageURL = game.imageURL {
            
            return imageURL
        }
        else {
            
            return nil
        }
    }
    
    public var viewerCountText: String {
        
        return "\(game.viewerCount) viewers"
    }
}
