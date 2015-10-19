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
    let name = "Defensive Stance"
    let description = "Forego an attack in favor of increased defense for this turn."
    
    let imageName = "DefensiveStance"
    let imageColor = UIColor.grayColor()
    
    let owner: Character
    
    init(owner: Character) {
        self.owner = owner
    }
    
    
    func execute(executor: Character, target: Character) {
        // TODO: Add this
    }
    
    func canExecuteOnTarget(target: Character) -> Bool {
        return true
    }
}