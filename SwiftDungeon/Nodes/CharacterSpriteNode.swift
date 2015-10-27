//
//  CharacterSpriteNode.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/19/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import SpriteKit

typealias CompletionBlock = (() -> Void)

enum CharacterSpriteAnimation {
    case None
    case Walk
    case Attack
    case CastSpell
    case Death
    case Hurt
}

class CharacterSpriteNode: SKNode {
    let baseName: String
    let character: Character
    
    let sprite: SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("CharacterSpriteNode does not conform to NSCoding")
    }
    
    init(character: Character) {
        self.character = character
        
        baseName = "\(self.character.name)Tile"

        sprite = SKSpriteNode()
        sprite.size = CGSize(width: 64, height: 64)
        
        super.init()
        

        if let frameIndex = character.walkAnimationFrameRange.minElement() {
            sprite.texture = textureForFrameIndex(frameIndex)
        }
        addChild(sprite)
    }
    
    func playAnimation(animation: CharacterSpriteAnimation, loop: Bool, completion: CompletionBlock?) {
        var frameRange: Range<Int>?
        switch animation {
        case .Attack: frameRange = character.attackAnimationFrameRange
        case .CastSpell: frameRange = character.spellAnimationFrameRange
        case .Walk: frameRange = character.walkAnimationFrameRange
        case .Death: frameRange = character.deathAnimationFrameRange
        default: frameRange = nil
        }
        
        if let frameRange = frameRange {
            var group: SKAction = SKAction()
            let animationAction = actionForAnimationRange(frameRange, loop: loop)
            let action = actionForAnimation(animation)
            if let animAction = animationAction {
                if let action = action {
                    action.duration = animAction.duration
                    group = SKAction.group([animAction, action])
                } else {
                    action?.duration = animAction.duration
                    group = animAction
                }
            } else {
                if let action = action {
                    group = action
                }
            }
            
            if let completion = completion {
                sprite.runAction(group, completion: completion)
            } else {
                sprite.runAction(group)
            }
        }
    }
    
    private func actionForAnimation(animation: CharacterSpriteAnimation) -> SKAction? {
        let duration  = 0.25
        switch animation {
        case .Attack: fallthrough
        case .CastSpell:
            let moveAction = SKAction.moveByX(character.isEnemy ? -20 : 20, y: 0, duration: duration)
            return SKAction.sequence([moveAction, moveAction.reversedAction()])
        case .Hurt:
            let redAction = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0.5, duration: 0.33)
            let redSequence = SKAction.sequence([redAction, redAction.reversedAction()])
            redSequence.timingMode = .EaseInEaseOut
            let blendAction = SKAction.colorizeWithColorBlendFactor(1.0, duration: 0.33)
            let blendSequence = SKAction.sequence([blendAction, blendAction.reversedAction()])
            blendSequence.timingMode = .EaseInEaseOut
            return SKAction.group([redSequence, blendSequence])
        default: return nil
        }
    }
    
    private func actionForAnimationRange(range: Range<Int>?, loop: Bool) -> SKAction? {
        if let range = range {
            let textures = range.map { textureForFrameIndex($0) }
            var animateAction = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: false, restore: true)
            if loop {
                animateAction = SKAction.repeatActionForever(animateAction)
            }
            return animateAction
        } else {
            return nil
        }
    }
    
    private func textureForFrameIndex(index: Int) -> SKTexture {
        return SKTexture(imageNamed: "\(baseName)-\(index)")
    }
    
}
