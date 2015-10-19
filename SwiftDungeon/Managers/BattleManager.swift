//
//  BattleManager.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

protocol BattleManagerDelegate {
    func didMoveToActiveCharacter(character: Character)
    func didStartBattle()
}

class BattleManager {
    static let sharedManager = BattleManager()
    
    var delegate: BattleManagerDelegate?
    
    var level = 1
    var players = [Character]()
    var enemies = [Character]()
    var combatQueue = [Character]()
    var activeCharacter: Character?
    
    func startBattle() {
        generateEnemies()
        
        combatQueue.removeAll()
        combatQueue.appendContentsOf(players)
        combatQueue.appendContentsOf(enemies)
        
        if let delegate = self.delegate {
            delegate.didStartBattle()
        }
        
        moveToNextCharacter()
    }
    
    func moveToNextCharacter() -> Character? {
        // Check entity status here to ensure they aren't stunned
        if let activeCharacter = combatQueue.filter({ $0.status != .Stunned }).first {
            combatQueue.insert(activeCharacter, atIndex: combatQueue.count)
            combatQueue.removeFirst()
            
            print("\(activeCharacter.name): \(activeCharacter.validAbilities)")
            
            self.activeCharacter = activeCharacter
            
            if let delegate = self.delegate {
                delegate.didMoveToActiveCharacter(activeCharacter)
            }
        }
        
        return activeCharacter
    }
    
    private func generateEnemies() {
        enemies.removeAll()
        
        var numEnemies = 1
        switch level {
        case 3...4: numEnemies = 2
        case 6...9: numEnemies = 4
        default: numEnemies = 1
        }
        
        for _ in 0...numEnemies - 1 {
            enemies.append(generateEnemy())
        }
    }
    
    private func generateEnemy() -> Character {
        return Rat()
    }
}