//
//  Damagable.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

protocol Damageable {
    var health: Int { get set }
    var maxHealth: Int { get }
}