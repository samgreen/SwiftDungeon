//
//  CharacterNode.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import SpriteKit

class CharacterNode: SKNode {
    let character: Character
    
    let sprite: CharacterSpriteNode
    let healthLabel = SKLabelNode(fontNamed: "PressStart2P")
    let abilityLabel = SKLabelNode(fontNamed: "PressStart2P")
    let statusLabel = SKLabelNode(fontNamed: "PressStart2P")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("CharacterNode does not support NSCoding")
    }
    
    init(character: Character) {
        self.character = character
        
        sprite = CharacterSpriteNode(character: self.character)
        if let texture = self.character.staticTexture {
            sprite.sprite.texture = texture
        }
        
        healthLabel.position = CGPoint(x: 0, y: -sprite.sprite.size.height * 0.5 - 18)
        healthLabel.fontSize = 14
        healthLabel.fontColor = UIColor.redColor()
        
        abilityLabel.position = CGPoint(x: 0, y: healthLabel.position.y - healthLabel.fontSize - 2)
        abilityLabel.fontSize = 14
        abilityLabel.fontColor = UIColor.blueColor()
        
        statusLabel.fontSize = 16
        statusLabel.alpha = 0.0
        
        super.init()
        
        self.character.node = self
        
        addChild(sprite)
        addChild(healthLabel)
        
        // Don't show AP for enemies
        if !character.isEnemy {
            addChild(abilityLabel)
        }
        
        addChild(statusLabel)
        
        updateFromCharacter()
    }
    
    func showStatusMessage(message: String, color: UIColor) {
        statusLabel.text = message
        statusLabel.fontColor = color
        statusLabel.alpha = 1.0
        let moveAction = SKAction.moveByX(0, y: -20, duration: 1)
        let fadeAction = SKAction.fadeOutWithDuration(0.5)
        statusLabel.runAction(SKAction.group([moveAction, fadeAction])) { self.statusLabel.position = CGPointZero }
    }
    
    func addSelectedAction() {
        let scaleAction = SKAction.scaleBy(1.1, duration: 0.25)
        let repeatScaleAction = SKAction.repeatActionForever(SKAction.sequence([scaleAction, scaleAction.reversedAction()]))
        healthLabel.runAction(repeatScaleAction, withKey: "selectedScaleAction")
        abilityLabel.runAction(repeatScaleAction, withKey: "selectedScaleAction")
    }
    
    func removeSelectedAction() {
        healthLabel.removeActionForKey("selectedScaleAction")
        healthLabel.setScale(1)
        
        abilityLabel.removeActionForKey("selectedScaleAction")
        abilityLabel.setScale(1)
    }
    
    func addAttackAnimation(complete: (() -> Void)) {
        let moveAction = SKAction.moveBy(CGVector(dx: character.isEnemy ? -5 : 5, dy: 0), duration: 0.33)
        let moveAndReverseAction = SKAction.sequence([moveAction, moveAction.reversedAction()])
        runAction(moveAndReverseAction, completion: complete)
    }
    
    func addDeathAnimation() {
        let alphaAction = SKAction.fadeOutWithDuration(0.33)
        runAction(alphaAction) {
            self.removeFromParent()
        }
    }
    
    func updateFromCharacter() {
        if character.isEnemy {
            healthLabel.text = "\(self.character.health)♥"
        } else {
            healthLabel.text = "\(self.character.health)/\(self.character.maxHealth)♥"
        }
        abilityLabel.text = "\(self.character.abilityPoints)/\(self.character.maxAbilityPoints)★"
        name = "Character: \(self.character.name)"
    }
}