//
//  HealAbility.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

class HealAbility: Ability {
    let cost = 2
    let name = "Heal"
    let description = "Completely heal a friendly target. Removes all negative status effects."
    
    let imageName = "Heal"
    let imageColor = UIColor.redColor()
    
    let owner: Character
    
    init(owner: Character) {
        self.owner = owner
    }
    
    func execute(executor: Character, target: Character) {
        target.health = target.maxHealth
        // Reset status effects
        target.status = .Normal
    }
    
    func canExecuteOnTarget(target: Character) -> Bool {
        if target.health == target.maxHealth || target.isEnemy {
            return false
        }
        
        return true
    }
}