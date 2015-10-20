//
//  Skeleton.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/19/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import SpriteKit

class Skeleton: EnemyCharacter {
    init() {
        super.init(health: 20, abilityPoints: 0, attackPower: 5)
        
        name = "Skeleton"
        staticTexture = SKTexture(imageNamed: "Skeleton")
    }
}