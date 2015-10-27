//
//  ShadowBladeAbility.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/18/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

class ShadowBladeAbility: Ability {
    let cost = 3
    let name = "Shadow Blade"
    let description = "Your blade darkens and does double damage to foes."
    let animationType: CharacterSpriteAnimation = .Attack
    let targetAnimationType: CharacterSpriteAnimation = .Hurt
    
    let imageName = "ShadowBlade"
    let imageColor = UIColor.purpleColor()
    
    let owner: Character
    
    init(owner: Character) {
        self.owner = owner
    }
    
    func execute(executor: Character, target: Character) {
        target.health -= executor.attackPower * 2
    }
    
    func canExecuteOnTarget(target: Character) -> Bool {
        return target.isEnemy
    }
}