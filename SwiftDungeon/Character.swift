//
//  Character.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

class Character: Entity {
    var node: CharacterNode?
    // MARK: Damageable Protocol
    var health: Int {
        didSet {
            if self.health > self.maxHealth {
                self.health = self.maxHealth
            } else if self.health < 0 {
                self.health = 0
            }
        }
    }
    var maxHealth: Int
    
    // MARK: Entity Protocol
    var abilityPoints: Int {
        didSet {
            if self.abilityPoints > self.maxAbilityPoints {
                self.abilityPoints = self.maxAbilityPoints
            } else if self.abilityPoints < 0 {
                self.abilityPoints = 0
            }
        }
    }
    var maxAbilityPoints: Int
    var attackPower: Int
    var status: EntityStatus = .Normal
    
    // MARK: Character
    var name = ""
    var abilities = [Ability]()
    var validAbilities: [Ability] { return abilities.filter { canExecuteAbility($0) } }
    var isEnemy = false
    var items = [Item]()
    
    init(health: Int, abilityPoints: Int, attackPower: Int) {
        self.health = health
        self.maxHealth = health
        
        self.abilityPoints = abilityPoints
        self.maxAbilityPoints = abilityPoints
        
        self.attackPower = attackPower
        
        self.abilities.append(BasicAttackAbility(owner: self))
    }
    
    func executeAbility(ability: Ability, target: Character) {
        if canExecuteAbility(ability) && ability.canExecuteOnTarget(target) {
            abilityPoints -= ability.cost
            ability.execute(self, target: target)
        }
    }
    
    func canExecuteAbility(ability: Ability) -> Bool {
        return abilityPoints >= ability.cost && health > 0
    }
}