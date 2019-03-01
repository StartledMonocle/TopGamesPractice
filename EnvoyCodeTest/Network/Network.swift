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
     Creates a URL request for the first 'Top Game' from Twitch which contains info on the total number of top games on Twitch which we need in order to set our collection view 'numberOfItemsInSection' to
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
     Executes tasks, each of which obtain data for a particular 'Game' object to be created and saved into a desired array
     
     - Parameter index: index of game
     
     gamesArray: Array containing games to be displayed in 'GameListViewControllers' collection view
     */
    func requestGame(forIndex: IndexPath, gamesArray: [Game?]) {
        
        if gamesArray[forIndex.row] != nil {
            // game is already loaded
            return
        }
    
        if Network.tasks[forIndex.row] != nil && Network.tasks[forIndex.row]!.state == URLSessionTask.State.running {
            // Wait for task to finish
            return
        }
    
        let task: URLSessionDataTask = self.getTopGameInfoTask(forIndex: forIndex, gamesArray: gamesArray)
    
        Network.tasks[forIndex.row] = task
        task.resume()
    }
}
