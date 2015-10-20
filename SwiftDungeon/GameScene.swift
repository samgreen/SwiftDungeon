//
//  GameScene.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright (c) 2015 Sam Green. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, BattleManagerDelegate, LevelManagerDelegate {
    var characterNodes = [CharacterNode]()
    var abilityNodes = [AbilityNode]()
    
    let levelLabel = SKLabelNode(fontNamed: "PressStart2P")
    var pendingAbility: Ability?
    
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFill
        
        BattleManager.sharedManager.delegate = self
        LevelManager.sharedManager.delegate = self
        
        LevelManager.sharedManager.addPlayer(Neophyte())
        LevelManager.sharedManager.addPlayer(Knight())
        LevelManager.sharedManager.addPlayer(Cleric())

        levelLabel.horizontalAlignmentMode = .Left
        levelLabel.fontSize = 12
        levelLabel.position = CGPoint(x: 4, y: CGRectGetMaxY(self.frame) - levelLabel.fontSize - 4)
        
        self.addChild(levelLabel)
        
        LevelManager.sharedManager.moveToNextLevel()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.locationInNode(self)
            
            // Process touches on enemy nodes
            let touchedCharacterNodes = characterNodes.filter {
                return CGRectContainsPoint($0.calculateAccumulatedFrame(), point)
            }
            
            if let node = touchedCharacterNodes.first {
                if let pendingAbility = self.pendingAbility {
                    if pendingAbility.canExecuteOnTarget(node.character) {
                        if let activeCharacter = BattleManager.sharedManager.activeCharacter {
                            activeCharacter.node?.addAttackAnimation {
                                activeCharacter.executeAbility(pendingAbility, target: node.character)
                                BattleManager.sharedManager.endTurn()
                            }
                            return
                        }
                    }
                }
            }
            
            // Process touches on ability nodes
            let touchedAbilityNodes = abilityNodes.filter {
                return CGRectContainsPoint($0.calculateAccumulatedFrame(), point)
            }
            
            if let node = touchedAbilityNodes.first {
                node.addSelectedAction()
                pendingAbility = node.ability
            } else {
                abilityNodes.forEach { $0.removeSelectedAction() }
                pendingAbility = nil
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        characterNodes.forEach { $0.updateFromCharacter() }
        abilityNodes.forEach { $0.updateFromAbility() }
    }
    
    // MARK: LevelManagerDelegate
    func didMoveToLevel(level: Int) {
        levelLabel.text = "Level \(level)"
        
        BattleManager.sharedManager.startBattle()
    }
    
    // MARK: BattleManagerDelegate
    func didStartBattle() {
        addNodesForLevel()
    }
    
    func didMoveToActiveCharacter(activeCharacter: Character) {
        characterNodes.forEach { $0.removeSelectedAction() }
        activeCharacter.node?.addSelectedAction()
        addAbilityNodesForCharacter(activeCharacter)
        
        if activeCharacter.isEnemy {
            let enemyCharacter = activeCharacter
            // AI Logic
            let randomPlayer = BattleManager.sharedManager.players.randomElement()
            if let basicAttack = enemyCharacter.abilities.last {
                if basicAttack.canExecuteOnTarget(randomPlayer) {
                    enemyCharacter.node?.addAttackAnimation {
                        enemyCharacter.executeAbility(basicAttack, target: randomPlayer)
                        BattleManager.sharedManager.endTurn()
                    }
                    return
                }
            }
        }
    }
    
    // MARK: Helpers
    private func addNodesForLevel() {
        for (i, enemy) in BattleManager.sharedManager.enemies.enumerate() {
            let node = CharacterNode(character: enemy)
            addCharacterNode(node, isEnemy: true, index: i)
        }
        
        for (i, player) in BattleManager.sharedManager.players.enumerate() {
            let node = CharacterNode(character: player)
            addCharacterNode(node, isEnemy: false, index: i)
        }
    }
    
    private func addCharacterNode(node: CharacterNode, isEnemy: Bool, index: Int) {
        let size = node.calculateAccumulatedFrame().size
        let xPadding: CGFloat = 70
        let ySpacing: CGFloat = 20 + size.height * 0.75
        let yPosition: CGFloat = CGRectGetMinY(self.frame) + ySpacing + CGFloat(index) * ySpacing
        if isEnemy {
            node.position = CGPoint(x: CGRectGetMaxX(self.frame) - xPadding, y: yPosition)
        } else {
            node.position = CGPoint(x: xPadding, y: yPosition)
        }
        
        characterNodes.append(node)
        addChild(node)
    }
    
    private func addAbilityNodesForCharacter(character: Character) {
        abilityNodes.forEach { $0.removeFromParent() }
        abilityNodes.removeAll()
        
        guard !character.isEnemy else { return }
        
        for (i, ability) in character.validAbilities.enumerate() {
            let node = AbilityNode(ability: ability)
            node.position = CGPoint(x: 200 + i * 80, y: 54)
            abilityNodes.append(node)
            addChild(node)
        }
    }
}
