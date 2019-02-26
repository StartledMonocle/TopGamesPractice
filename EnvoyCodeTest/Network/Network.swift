//
//  Network.swift
//  EnvoyCodeTest
//
//  Created by Long Le on 2/12/19.
//  Copyright © 2019 Envoy. All rights reserved.
//

import Foundation

class Network {

    static var tasks = [URLSessionDataTask?]()
    
    
    /**
     Makes a URL request for the first 'Top Game' from Twitch which contains info on the total number of top games on Twitch which we need in order to set our collection view 'numberOfItemsInSection' to
     */
    func initialRequest(completionHandler: @escaping (_ json: [String: Any]) -> Void) {
        
        let url = URL(string: "https://api.twitch.tv/kraken/games/top?limit=1&offset=0&client_id=nq033i1s4i5vgvu8q9pqot96ugl9dd")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let _ = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                
                //dataResponse received from a network request
                let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]

                //set size of tasks to total number of 'Top Games' from Twitch
                Network.tasks = [URLSessionDataTask?](repeating: nil, count: json!["_total"] as! Int)
                
                completionHandler(json!)
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    /**
     Generates URL for game located at index
     
     - Parameter index: index of game

     - Returns: URL for game info JSON
     */
    func urlComponents(index: Int) -> URL {
        
        let url = URL(string: "https://api.twitch.tv/kraken/games/top?limit=\(1)&offset=\(index)&client_id=nq033i1s4i5vgvu8q9pqot96ugl9dd")
        
        return url!
    }
    
    /**
     Generates a URLSessionDataTask to obtain JSON from URL. Once data is obtained, a 'Game' object will be created using the JSON data and added to 'GameListViewControllers' data source
     
     - Parameter index: index of game

     - Returns: URLSessionDataTask to obtain JSON data for the game at the index
     */
    func getTask(forIndex: IndexPath) -> URLSessionDataTask {
        
        let url = urlComponents(index: forIndex.row)
        
        return URLSession.shared.dataTask(with: url) { data, response, error in
            
            var _name : String = ""
            var _viewerCount = 0
            var _id : Int32 = 0
            var _imageURL : URL? = nil
            
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let topGames = json["top"] as? [[String: Any]] {
                    for games in topGames {
                        
                        if let game = games["game"] as? [String:Any] {
                            
                            if let name = game["name"] as? String {
                                
                                _name = name
                            }
                            
                            if let id = game["_id"] as? Int32 {
                                
                                _id = id
                            }
                            
                            if let numOfViewers = games["viewers"] as? Int {
                                
                                _viewerCount = numOfViewers
                            }
                            
                            if let box = game["box"] as? [String:Any] {
                                
                                if let large = box["large"] as? String {
                                    
                                    _imageURL = (NSURL(string: large)! as URL)
                                }
                            }
                            
                            DispatchQueue.main.async() {

                                let game = Game(id: _id, name: _name, image: _imageURL!, viewerCount: _viewerCount)

                                var gameAlreadyExistsInArray = false
                                if GamesListViewController.gamesArray.contains(where: { $0?.name == _name }) {
                                    gameAlreadyExistsInArray = true
                                }
                                
                                if gameAlreadyExistsInArray == false {
                                    
                                    GamesListViewController.gamesArray[forIndex.row] = game
                                    let nc = NotificationCenter.default
                                    nc.post(name: Notification.Name("GameAdded"), object: forIndex)
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
    
    /**
     Creates a URLSessionDataTask which obtains 'Game' info we want from Twitch. Task is added to an array which will run sequentially
     
     - Parameter index: index of game
     
     gamesArray: Array containing games to be displayed in 'GameListViewControllers' collection view
     */
    func requestGame(forIndex: IndexPath, gamesArray: [Game?]) {
        let task: URLSessionDataTask
        
        if gamesArray[forIndex.row] != nil {
            // game is already loaded
            return
        }
    
        if Network.tasks[forIndex.row] != nil && Network.tasks[forIndex.row]!.state == URLSessionTask.State.running {
            // Wait for task to finish
            return
        }
    
        task = self.getTask(forIndex: forIndex)
    
        Network.tasks[forIndex.row] = task
        task.resume()
    }
}
