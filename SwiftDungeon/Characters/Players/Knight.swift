//
//  Knight.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

class Knight: Character {
    init() {
        super.init(health: 25, abilityPoints: 8, attackPower: 15)
        
        name = "Knight"
        
        abilities.append(DefensiveStanceAbility(owner: self))
        abilities.append(ShadowBladeAbility(owner: self))
    }
}