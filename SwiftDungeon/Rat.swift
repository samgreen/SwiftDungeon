//
//  Rat.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

class Rat: EnemyCharacter {
    init() {
        super.init(health: 20, abilityPoints: 0, attackPower: 5)
        
        name = "Rat"
    }
}