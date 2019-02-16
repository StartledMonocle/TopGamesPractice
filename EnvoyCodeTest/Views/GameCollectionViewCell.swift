//
//  GameCollectionViewCell.swift
//  EnvoyCodeTest
//
//  Created by Long Le on 2/7/19.
//  Copyright © 2019 Envoy. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gameCover: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var numOfPeopleWatchingLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
}

