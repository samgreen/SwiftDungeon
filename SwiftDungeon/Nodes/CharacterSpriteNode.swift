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
    case Walk
    case Attack
    case CastSpell
    case Death
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
        var frameRange: Range<Int>
        switch animation {
        case .Attack: frameRange = character.attackAnimationFrameRange
        case .CastSpell: frameRange = character.spellAnimationFrameRange
        case .Walk: frameRange = character.walkAnimationFrameRange
        case .Death: frameRange = character.deathAnimationFrameRange
        }
        
        var group: SKAction
        let animationAction = actionForAnimationRange(frameRange, loop: loop)
        let action = actionForAnimation(animation)
        if let action = action {
            action.duration = animationAction.duration
            group = SKAction.group([animationAction, action])
        } else {
            group = animationAction
        }
        
        if let completion = completion {
            sprite.runAction(group, completion: completion)
        } else {
            sprite.runAction(group)
        }
    }
    
    private func actionForAnimation(animation: CharacterSpriteAnimation) -> SKAction? {
        let duration  = 0.25
        switch animation {
        case .Attack: fallthrough
        case .CastSpell:
            let moveAction = SKAction.moveByX(character.isEnemy ? -20 : 20, y: 0, duration: duration)
            return SKAction.sequence([moveAction, moveAction.reversedAction()])
        case .Walk: return nil
        case .Death: return nil
        }
    }
    
    private func actionForAnimationRange(range: Range<Int>, loop: Bool) -> SKAction {
        let textures = range.map { textureForFrameIndex($0) }
        var animateAction = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: false, restore: true)
        if loop {
            animateAction = SKAction.repeatActionForever(animateAction)
        }
        return animateAction
    }
    
    private func textureForFrameIndex(index: Int) -> SKTexture {
        return SKTexture(imageNamed: "\(baseName)-\(index)")
    }
    
}
