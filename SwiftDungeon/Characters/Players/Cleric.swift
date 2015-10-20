//
//  Cleric.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/18/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

class Cleric: Character {
    
    init() {
        super.init(health: 8, abilityPoints: 18, attackPower: 8)
        
        name = "Cleric"
        
        abilities.append(DefensiveStanceAbility(owner: self))
        abilities.append(HealAbility(owner: self))
        abilities.append(GroupHealAbility(owner: self))
    }
}