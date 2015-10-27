//
//  DefensiveStanceAbility.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/18/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

class DefensiveStanceAbility: Ability {
    let cost = 2
    let name = "Hunker Down"
    let description = "Forego an attack in favor of increased defense for this turn."
    let animationType: CharacterSpriteAnimation = .CastSpell
    let targetAnimationType: CharacterSpriteAnimation = .None
    
    let imageName = "DefensiveStance"
    let imageColor = UIColor.grayColor()
    
    let owner: Character
    
    init(owner: Character) {
        self.owner = owner
    }
    
    func execute(executor: Character, target: Character) {
        executor.damageReduction = 0.5
    }
    
    func canExecuteOnTarget(target: Character) -> Bool {
        return true
    }
}