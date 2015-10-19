//
//  EnemyCharacter.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

class EnemyCharacter: Character {
    override init(health: Int, abilityPoints: Int, attackPower: Int) {
        super.init(health: health, abilityPoints: abilityPoints, attackPower: attackPower)
        
        isEnemy = true
    }
}