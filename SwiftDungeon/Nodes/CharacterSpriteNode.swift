//
//  CharacterSpriteNode.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/19/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import SpriteKit

/*
    Animation sequence information:
    Bow animation:
    1-9 Raise bow and aim
    10 Loose arrow
    11-13 Grab new arrow
    5-9 Aim new arrow
    10 Loose new arrow

    Thrust animation:
    1-4 Raise staff
    5-8 Thrust loop.

    Skeleton (and male) walk animation:
    1 Stand/idle
    2-9 Walkcycle
*/

enum CharacterSpriteLayer: String {
    case Behind = "BEHIND"
    case Body = "BODY"
    case Feet = "FEET"
    case Legs = "LEGS"
    case Torso = "TORSO"
    case Belt = "BELT"
    case Head = "HEAD"
    case Hands = "HANDS"
    case Weapon = "WEAPON"
}

class CharacterSpriteNode: SKNode {
    let baseName: String
    let walkFrames: [String]
    let numFrames = 9
    
    let sprite: SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("CharacterSpriteNode does not conform to NSCoding")
    }
    
    init(baseName: String) {
        self.baseName = baseName
        walkFrames = (1...numFrames).map { "\(baseName)Walk\($0)" }
        sprite = SKSpriteNode(imageNamed: walkFrames[0])
        sprite.setScale(2)
        
        super.init()
        
        addChild(sprite)
    }
}