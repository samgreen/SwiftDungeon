//
//  LevelManager.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

protocol LevelManagerDelegate {
    func didMoveToLevel(level: Int)
}

class LevelManager {
    static let sharedManager = LevelManager()
    
    var delegate: LevelManagerDelegate?
    
    var level = 6
    var isBossLevel: Bool { return level % 10 == 5 || level % 10 == 0 }
    
    func moveToNextLevel() {
        level++
        
        if let delegate = self.delegate {
            delegate.didMoveToLevel(level)
        }
    }
    
    func addPlayer(player: Character) {
        BattleManager.sharedManager.players.append(player)
    }
}