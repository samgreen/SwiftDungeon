//
//  Ability.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

protocol Ability: Drawable {
    var name: String { get }
    var description: String { get }
    var cost: Int { get } // Cost in ability points
    
    var owner: Character { get }
    
    func execute(executor: Character, target: Character)
    func canExecuteOnTarget(target: Character) -> Bool
}