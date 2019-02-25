//
//  Game.swift
//  EnvoyCodeTest
//
//  Created by Long Le on 2/9/19.
//  Copyright © 2019 Envoy. All rights reserved.
//

import Foundation
import UIKit

public class Game {
    
    public var id: Int32
    public var name: String
    public var imageURL: URL?
    public var viewerCount: Int
    
    public init(id: Int32, name: String, image: URL?, viewerCount: Int) {
        
        self.id = id
        self.name = name
        self.imageURL = image
        self.viewerCount = viewerCount
    }
}



