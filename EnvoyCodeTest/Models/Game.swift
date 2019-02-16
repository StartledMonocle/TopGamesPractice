//
//  Game.swift
//  EnvoyCodeTest
//
//  Created by Long Le on 2/9/19.
//  Copyright © 2019 Envoy. All rights reserved.
//

import Foundation

struct Game {
    
    var coverArtURL: URL?
    var title: String
    var id: Int
    var viewers: Int
    
    init() {
        
        coverArtURL = nil
        title = ""
        id = 0
        viewers = 0
    }
}



