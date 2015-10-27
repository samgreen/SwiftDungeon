//
//  BasicAttack.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

class BasicAttackAbility: Ability {
    let cost = 0
    let name = "Attack"
    let description = "Default attack does damage equal to your attack power."
    let animationType: CharacterSpriteAnimation = .Attack
    let targetAnimationType: CharacterSpriteAnimation = .Hurt
    
    let imageName = "BasicAttack"
    let imageColor = UIColor.orangeColor()
    
    let owner: Character
    
    init(owner: Character) {
        self.owner = owner
    }
    
    func execute(executor: Character, target: Character) {
        target.health -= executor.attackPower
    }
    
    func canExecuteOnTarget(target: Character) -> Bool {
        return owner.isEnemy != target.isEnemy
    }
}