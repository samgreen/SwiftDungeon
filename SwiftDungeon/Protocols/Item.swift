//
//  Item.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

enum ItemRank {
    case Common
    case Uncommon
    case Legendary
    case Epic
}

protocol Item {
    var name: String { get }
    var price: Int { get }
    var rank: ItemRank { get }
    
    var abilityPointsModifier: Int { get }
    var healthModifier: Int { get }
    var attackPowerModifier: Int { get }
}