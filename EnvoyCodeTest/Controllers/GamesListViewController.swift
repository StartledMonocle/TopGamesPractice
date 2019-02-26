//
//  ViewController.swift
//  EnvoyCodeTest
//
//  Created by Envoy on 10/15/17.
//  Copyright © 2017 Envoy. All rights reserved.
//

import UIKit

class GamesListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
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
        
        
        //obtains info from twitch on the total number of games which we use to set our collection view size to
        Network().initialRequest { (json) in
            
            self.totalGamesCount = json["_total"] as! Int
            GamesListViewController.gamesArray = [Game?](repeating: nil, count: self.totalGamesCount)
            
            self.isInitialRequestComplete = true
            
            DispatchQueue.main.async() {
                
                //reload collection view to set collection view size to total number of Top Games on Twitch
                self.gamesCollectionView.reloadData()
                
                //request data on the first 20 games from Twitch so that we can display it when the app launches
                for i in 0...20 {
                    let indexPath = IndexPath(row: i, section: 0)
                    Network().requestGame(forIndex: indexPath, gamesArray: GamesListViewController.gamesArray)
                }
            }
        }
    }
    
    
    // Mark: UICollectionView Delegate methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.isInitialRequestComplete ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.isInitialRequestComplete ? self.totalGamesCount : 0
    }
    
    //Prefetches data for games on demand based on the speed and direction the user scrolls
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            Network().requestGame(forIndex: indexPath, gamesArray: GamesListViewController.gamesArray)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = gamesCollectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        
        if GamesListViewController.gamesArray.count > 0, let game = GamesListViewController.gamesArray[indexPath.row] {
        
            DispatchQueue.global().async {
                
                if let imageURL = game.imageURL, let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                    
                        DispatchQueue.main.async {
                            
                            let gameModel = Game(id: game.id, name: game.name, image: imageURL, viewerCount: game.viewerCount)
                            let gameViewModel = GameViewModel(game: gameModel)
                            
                            cell.image.image = image
                            cell.name.text = gameViewModel.name
                            cell.viewerCount.text = gameViewModel.viewerCountText
                    }
                }
                else {  //game image doesn't exist, just display game name and viewer count
                    
                    DispatchQueue.main.async {
                        
                        let gameModel = Game(id: game.id, name: game.name, image: nil, viewerCount: game.viewerCount)
                        let gameViewModel = GameViewModel(game: gameModel)
                        
                        cell.name.text = gameViewModel.name
                        cell.viewerCount.text = gameViewModel.viewerCountText
                    }
                }
            }
        }
        else {
            
            Network().requestGame(forIndex: indexPath, gamesArray: GamesListViewController.gamesArray)
        }
        
        return cell
    }
        
    
    
    // MARK: UI Set up
    
    func setCollectionViewFlowLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 110, height: 180)
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        flowLayout.minimumInteritemSpacing = 0.0
        self.gamesCollectionView.collectionViewLayout = flowLayout
    }
    
    
    // MARK: Notification Center
    
    @objc func gameAdded(notification: Notification) {
        
        let indexPath = notification.object as! IndexPath
        self.gamesCollectionView.reloadItems(at: [indexPath])
    }
}
