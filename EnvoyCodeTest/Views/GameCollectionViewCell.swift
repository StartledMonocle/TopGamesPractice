//
//  GameCollectionViewCell.swift
//  EnvoyCodeTest
//
//  Created by Long Le on 2/7/19.
//  Copyright © 2019 Envoy. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var viewerCount: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
}

