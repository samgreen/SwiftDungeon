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
    func didEndBattle()
    
    func didStartTurn()
    func didEndTurn()
}

class BattleManager {
    static let sharedManager = BattleManager()
    
    var delegate: BattleManagerDelegate?

    var players = [Character]()
    var enemies = [Character]()
    var livingCharacters: [Character] {
        var characters = [Character]()
        characters.appendContentsOf(self.players.filter { $0.health <= 0 })
        characters.appendContentsOf(self.enemies.filter { $0.health <= 0 })
        return characters
    }
    var combatQueue = Queue<Character>()
    var activeCharacter: Character?
    
    func startBattle() {
        generateEnemies()
        
        combatQueue.removeAll()
        players.forEach { combatQueue.enqueue($0) }
        enemies.forEach { combatQueue.enqueue($0) }
        
        if let delegate = self.delegate {
            delegate.didStartBattle()
        }
    }
    
    func endTurn() {
        let deadPlayers = players.filter { $0.health <= 0 }
        deadPlayers.forEach { $0.node?.addDeathAnimation() }
        
        let deadEnemies = enemies.filter { $0.health <= 0 }
        deadEnemies.forEach { $0.node?.addDeathAnimation() }
        
        if let delegate = self.delegate {
            if deadPlayers.count == players.count || deadEnemies.count == enemies.count {
                delegate.didEndBattle()
            } else {
                delegate.didEndTurn()
            }
        }
    }
    
    func moveToNextCharacter() {
        // Check entity status here to ensure they aren't stunned
        if let activeCharacter = combatQueue.dequeue() {
            print("\(activeCharacter.name): \(activeCharacter.validAbilities)")
            
            self.activeCharacter = activeCharacter
            
            if let delegate = self.delegate {
                delegate.didMoveToActiveCharacter(activeCharacter)
            }
            
            combatQueue.enqueue(activeCharacter)
        }
    }
    
    func nextActiveCharacter() -> Character? {
        var character: Character? = nil
        repeat {
            character = combatQueue.dequeue()
        } while character != nil
        
        return character
    }
    
    func performAbilityForCharacter(ability: Ability?, character: Character?, target: Character?) -> Bool {
        if let character = character {
            if let ability = ability {
                if let target = target {
                    if character.isEnemy {
                        character.node?.sprite.playAnimation(ability.animationType, loop: false) {
                            character.executeAbility(ability, target: target)
                            BattleManager.sharedManager.endTurn()
                        }
                    } else {
                        character.node?.showStatusMessage(ability.name, color: ability.imageColor)
                        character.node?.sprite.playAnimation(ability.animationType, loop: false) {
                            character.executeAbility(ability, target: target)
                            BattleManager.sharedManager.endTurn()
                        }
                    }
                    return true
                }
            }
        }
        return false
    }
    
    private func generateEnemies() {
        enemies.removeAll()
        
        let numEnemies = Int(ceilf(Float(LevelManager.sharedManager.level) / 2))
        for _ in 0...numEnemies - 1 {
            enemies.append(generateEnemy())
        }
    }
    
    private func generateEnemy() -> Character {
        return Skeleton()
    }
}