//
//  GamesListViewController+Extensions.swift
//  EnvoyCodeTest
//
//  Created by Long Le on 2/26/19.
//  Copyright © 2019 Envoy. All rights reserved.
//

import Foundation
import UIKit

extension GamesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
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
                        
                        let gameViewModel = GameViewModel(game: game)
                        
                        cell.name.text = gameViewModel.name
                        cell.viewerCount.text = gameViewModel.viewerCountText
                        cell.gameImage.image = image
                    }
                }
                else {  //game image doesn't exist, just display game name and viewer count
                    
                    DispatchQueue.main.async {
                        
                        let gameViewModel = GameViewModel(game: game)
                        
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
}
