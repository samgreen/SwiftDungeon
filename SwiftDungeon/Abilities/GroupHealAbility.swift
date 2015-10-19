//
//  GroupHealAbiltiy.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/18/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

class GroupHealAbility: Ability {
    let cost = 6
    let name = "Group Heal"
    let description = "Heals all players for double your attack power."
    
    let imageName = "GroupHeal"
    let imageColor = UIColor.redColor()
    
    let owner: Character
    
    init(owner: Character) {
        self.owner = owner
    }
    
    func execute(executor: Character, target: Character) {
        // Ignore target for this ability
        BattleManager.sharedManager.players.forEach {
            $0.health += executor.attackPower * 2
        }
    }
    
    func canExecuteOnTarget(target: Character) -> Bool {
        if target.health == target.maxHealth || owner.isEnemy != target.isEnemy {
            return false
        }
        
        return true
    }
}