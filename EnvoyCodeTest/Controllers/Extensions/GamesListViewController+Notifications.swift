//
//  GamesListViewController+Notifications.swift
//  EnvoyCodeTest
//
//  Created by Long Le on 2/26/19.
//  Copyright © 2019 Envoy. All rights reserved.
//

import Foundation

extension GamesListViewController {
    
    @objc func gameAdded(notification: Notification) {
        
        let indexPath = notification.object as! IndexPath
        self.gamesCollectionView.reloadItems(at: [indexPath])
    }
}
