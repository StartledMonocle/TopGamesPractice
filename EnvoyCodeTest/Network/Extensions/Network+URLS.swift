//
//  Network+URLS.swift
//  EnvoyCodeTest
//
//  Created by Long Le on 3/1/19.
//  Copyright © 2019 Envoy. All rights reserved.
//

import Foundation

extension Network {
    
    /**
     Generates URL for game located at index
     
     - Parameter index: index of game
     
     - Returns: URL for game info JSON
     */
    func urlComponents(index: Int) -> URL {
        
        let url = URL(string: "https://api.twitch.tv/kraken/games/top?limit=\(1)&offset=\(index)&client_id=nq033i1s4i5vgvu8q9pqot96ugl9dd")
        
        return url!
    }
}
