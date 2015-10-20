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
    let nameLabel: SKLabelNode = SKLabelNode(fontNamed: "PressStart2P")
    let healthLabel: SKLabelNode = SKLabelNode(fontNamed: "PressStart2P")
    let abilityLabel: SKLabelNode = SKLabelNode(fontNamed: "PressStart2P")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("CharacterNode does not support NSCoding")
    }
    
    init(character: Character) {
        self.character = character
        
        sprite = CharacterSpriteNode(baseName: character.name)
        
        nameLabel.position = CGPoint(x: 0, y: -sprite.sprite.size.height * 0.5 - 18)
        nameLabel.fontSize = 16
        nameLabel.horizontalAlignmentMode = .Center
        
        healthLabel.position = CGPoint(x: 0, y: nameLabel.position.y - nameLabel.fontSize - 2)
        healthLabel.fontSize = 14
        healthLabel.fontColor = UIColor.redColor()
        
        abilityLabel.position = CGPoint(x: 0, y: healthLabel.position.y - healthLabel.fontSize - 2)
        abilityLabel.fontSize = 14
        abilityLabel.fontColor = UIColor.blueColor()
        
        super.init()
        
        self.character.node = self
        
        addChild(sprite)
        addChild(nameLabel)
        addChild(healthLabel)
        
        // Don't show AP for enemies
        if !character.isEnemy {
            addChild(abilityLabel)
        }
        
        updateFromCharacter()
    }
    
    func addSelectedAction() {
        let scaleAction = SKAction.scaleBy(1.05, duration: 0.5)
        let repeatScaleAction = SKAction.repeatActionForever(SKAction.sequence([scaleAction, scaleAction.reversedAction()]))
        runAction(repeatScaleAction, withKey: "selectedScaleAction")
    }
    
    func removeSelectedAction() {
        removeActionForKey("selectedScaleAction")
        xScale = 1
        yScale = 1
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
        nameLabel.text = self.character.name
        if character.isEnemy {
            healthLabel.text = "\(self.character.health)♥"
        } else {
            healthLabel.text = "\(self.character.health)/\(self.character.maxHealth)♥"
        }
        abilityLabel.text = "\(self.character.abilityPoints)/\(self.character.maxAbilityPoints)★"
        name = "Character: \(self.character.name)"
    }
}