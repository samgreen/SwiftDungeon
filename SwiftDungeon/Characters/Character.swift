//
//  Character.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import SpriteKit

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
    var damageReduction: Float = 0
    
    // MARK: Character
    var name = ""
    var abilities = [Ability]()
    var validAbilities: [Ability] { return abilities.filter { canExecuteAbility($0) } }
    var isEnemy = false
    var items = [Item]()
    
    var staticTexture: SKTexture?
    
    let deathAnimationFrameRange = 260...265
    let walkAnimationFrameRange = 143...151
    let spellAnimationFrameRange = 39...45
    let attackAnimationFrameRange = 195...200
    
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
            
            if target.isEnemy {
                if let node = target.node {
                    let redAction = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0.5, duration: 0.33)
                    let redSequence = SKAction.sequence([redAction, redAction.reversedAction()])
                    redSequence.timingMode = .EaseInEaseOut
                    let blendAction = SKAction.colorizeWithColorBlendFactor(1.0, duration: 0.33)
                    let blendSequence = SKAction.sequence([blendAction, blendAction.reversedAction()])
                    blendSequence.timingMode = .EaseInEaseOut
                    node.sprite.sprite.runAction(SKAction.group([redSequence, blendSequence]))
                }
            }
        }
    }
    
    func canExecuteAbility(ability: Ability) -> Bool {
        return abilityPoints >= ability.cost && health > 0
    }
}