//
//  GamesListViewController+ViewSetup.swift
//  EnvoyCodeTest
//
//  Created by Long Le on 2/26/19.
//  Copyright © 2019 Envoy. All rights reserved.
//

import UIKit

extension GamesListViewController {

    func setCollectionViewFlowLayout() {
    
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 110, height: 180)
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        flowLayout.minimumInteritemSpacing = 0.0
        self.gamesCollectionView.collectionViewLayout = flowLayout
    }
}
