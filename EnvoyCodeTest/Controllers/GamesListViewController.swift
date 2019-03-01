//
//  ViewController.swift
//  EnvoyCodeTest
//
//  Created by Envoy on 10/15/17.
//  Copyright © 2017 Envoy. All rights reserved.
//

import UIKit

class GamesListViewController: UIViewController {
    
    static var gamesArray = [Game?]()
    var totalGamesCount : Int = 0
    var isInitialRequestComplete = false

    @IBOutlet weak var gamesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        gamesCollectionView.prefetchDataSource = self
        
        self.gamesCollectionView.register(UINib(nibName: "GameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GameCollectionViewCell")

        self.setCollectionViewFlowLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameAdded), name: Notification.Name("GameAdded"), object: nil)
        
        
        //obtain total # of games from Twitch, set our collection view size to this #
        Network().initialRequest { (json) in
            
            self.totalGamesCount = json["_total"] as! Int
            GamesListViewController.gamesArray = [Game?](repeating: nil, count: self.totalGamesCount)
            
            self.isInitialRequestComplete = true
            
            DispatchQueue.main.async() {
                
                //reload collection view to set the collection view size to the total number of games being streamed on Twitch
                self.gamesCollectionView.reloadData()
            }
        }
    }
}
