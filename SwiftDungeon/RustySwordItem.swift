//
//  RustySwordItem.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

class RustySwordItem: Item {
    var rank: ItemRank = .Common
    var name = "Rusty Sword"
    var price = 0
    
    var abilityPointsModifier = 0
    var healthModifier = 0
    var attackPowerModifier = 5
}