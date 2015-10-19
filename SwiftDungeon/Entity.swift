//
//  Entity.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

enum EntityStatus {
    case Normal
    case Stunned
    case Poisoned
}

protocol Entity: Damageable {
    var abilityPoints: Int { get set }
    var maxAbilityPoints: Int { get }
    var status: EntityStatus { get set }
    var attackPower: Int { get }
}