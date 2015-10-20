//
//  BattleManager.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

protocol BattleManagerDelegate {
    func didMoveToActiveCharacter(activeCharacter: Character)
    func didStartBattle()
}

class BattleManager {
    static let sharedManager = BattleManager()
    
    var delegate: BattleManagerDelegate?

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
    
    func endTurn() {
        combatQueue = combatQueue.filter { $0.health > 0 }
        
        let deadPlayers = players.filter { $0.health <= 0 }
        deadPlayers.forEach { $0.node?.addDeathAnimation() }
        
        let deadEnemies = enemies.filter { $0.health <= 0 }
        deadEnemies.forEach { $0.node?.addDeathAnimation() }
        
        moveToNextCharacter()
    }
    
    func moveToNextCharacter() {
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
    }
    
    private func generateEnemies() {
        enemies.removeAll()
        
        let numEnemies = Int(ceilf(Float(LevelManager.sharedManager.level) / 2))
        for _ in 0...numEnemies - 1 {
            enemies.append(generateEnemy())
        }
    }
    
    private func generateEnemy() -> Character {
        return Rat()
    }
}