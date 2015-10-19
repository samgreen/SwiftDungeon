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
    
    let sprite: SKSpriteNode = SKSpriteNode()
    let nameLabel: SKLabelNode = SKLabelNode(fontNamed: "PressStart2P")
    let healthLabel: SKLabelNode = SKLabelNode(fontNamed: "PressStart2P")
    let abilityLabel: SKLabelNode = SKLabelNode(fontNamed: "PressStart2P")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("CharacterNode does not support NSCoding")
    }
    
    init(character: Character) {
        self.character = character
        
        sprite.size = CGSize(width: 32, height: 32)
        
        nameLabel.position = CGPoint(x: 0, y: -sprite.frame.size.height - 6)
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
        addChild(abilityLabel)
        
        updateFromCharacter()
    }
    
    func addSelectedAction() {
        let scaleAction = SKAction.scaleBy(1.05, duration: 0.5)
        let repeatScaleAction = SKAction.repeatActionForever(SKAction.sequence([scaleAction, scaleAction.reversedAction()]))
        runAction(repeatScaleAction, withKey: "selectedScaleAnimation")
    }
    
    func removeSelectedAction() {
        removeActionForKey("selectedScaleAnimation")
        xScale = 1
        yScale = 1
    }
    
    func updateFromCharacter() {
        nameLabel.text = self.character.name
        healthLabel.text = "\(self.character.health)/\(self.character.maxHealth)♥"
        abilityLabel.text = "\(self.character.abilityPoints)/\(self.character.maxAbilityPoints)★"
        name = "Character: \(self.character.name)"
    }
}