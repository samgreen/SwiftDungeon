//
//  AbilityNode.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/18/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import SpriteKit

class AbilityNode: SKNode {
    let ability: Ability
    
    let sprite: SKSpriteNode
    let nameLabel: SKLabelNode = SKLabelNode(fontNamed: "PressStart2P")
    let abilityLabel: SKLabelNode = SKLabelNode(fontNamed: "PressStart2P")
    let border: SKShapeNode = SKShapeNode(rectOfSize: CGSize(width: 61, height: 61))
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("CharacterNode does not support NSCoding")
    }
    
    init(ability: Ability) {
        self.ability = ability
        
        sprite = SKSpriteNode(imageNamed: ability.imageName)
        sprite.color = ability.imageColor
        sprite.colorBlendFactor = 1.0
        sprite.size = CGSize(width: 64, height: 64)
        sprite.zPosition = 100
        
        border.strokeColor = UIColor.blueColor()
        border.lineWidth = 3
        border.lineJoin = .Miter
        border.hidden = true
        border.zPosition = sprite.zPosition + 10
        
        nameLabel.position = CGPoint(x: 0, y: sprite.size.height * 0.5 + 4)
        nameLabel.fontSize = 6
        nameLabel.fontColor = ability.imageColor
        nameLabel.horizontalAlignmentMode = .Center
        
        abilityLabel.position = CGPoint(x: 0, y: -50)
        abilityLabel.fontSize = 10
        abilityLabel.fontColor = UIColor.blueColor()
        abilityLabel.horizontalAlignmentMode = .Center
        
        super.init()
        
        addChild(sprite)
        addChild(border)
        addChild(nameLabel)
        addChild(abilityLabel)
        
        updateFromAbility()
    }
    
    func addSelectedAction() {
        border.hidden = false
        nameLabel.fontColor = UIColor.whiteColor()
    }
    
    func removeSelectedAction() {
        border.hidden = true
        nameLabel.fontColor = ability.imageColor
    }
    
    func updateFromAbility() {
        nameLabel.text = self.ability.name
        abilityLabel.text = "\(self.ability.cost)★"
        name = "Ability: \(self.ability.name)"
        
        alpha = ability.owner.canExecuteAbility(ability) ? 1.0 : 0.5
    }
}