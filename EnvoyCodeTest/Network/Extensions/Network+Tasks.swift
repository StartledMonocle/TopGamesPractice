//
//  Network+Tasks.swift
//  EnvoyCodeTest
//
//  Created by Long Le on 3/1/19.
//  Copyright © 2019 Envoy. All rights reserved.
//

import Foundation

extension Network {
    
    /**
     Generates a URLSessionDataTask to obtain JSON from URL. The returned data task creates a 'Game' object and adds it to the desired array
     
     - Parameter index: index of game
     
     - Returns: URLSessionDataTask to obtain JSON data for the game at the index
     */
    func getTopGameInfoTask(forIndex: IndexPath, gamesArray: [Game?]) -> URLSessionDataTask {
        
        let url = urlComponents(index: forIndex.row)
        
        return URLSession.shared.dataTask(with: url) { data, response, error in
            
            let newGame : Game = Game(id: 0, name: nil, image: nil, viewerCount: 0)
            
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let topGames = json["top"] as? [[String: Any]] {
                    for games in topGames {
                        
                        if let game = games["game"] as? [String:Any] {
                            
                            if let name = game["name"] as? String {
                                
                                newGame.name = name
                            }
                            
                            if let id = game["_id"] as? Int32 {
                                
                                newGame.id = id
                            }
                            
                            if let viewerCount = games["viewers"] as? Int {
                                
                                newGame.viewerCount = viewerCount
                            }
                            
                            if let box = game["box"] as? [String:Any], let large = box["large"] as? String {
                                
                                newGame.imageURL = (NSURL(string: large)! as URL)
                            }
                            
                            DispatchQueue.main.async() {
                                
                                var gameAlreadyExistsInArray = false
                                if gamesArray.contains(where: { $0?.name == newGame.name }) {
                                    gameAlreadyExistsInArray = true
                                }
                                
                                if gameAlreadyExistsInArray == false {
                                    
                                    GamesListViewController.gamesArray[forIndex.row] = newGame
                                    let notif = NotificationCenter.default
                                    notif.post(name: Notification.Name("GameAdded"), object: forIndex)
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
    }
}
