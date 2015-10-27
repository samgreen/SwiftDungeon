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
    let currentCharacterLabel = SKLabelNode(fontNamed: "PressStart2P")
    var pendingAbility: Ability?
    let backgroundNode = SKSpriteNode(imageNamed: "Background0")
    
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFill
        
        backgroundNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        backgroundNode.zPosition = -1000
        backgroundNode.setScale(3.2)
        addChild(backgroundNode)
        
        levelLabel.horizontalAlignmentMode = .Left
        levelLabel.fontSize = 12
        levelLabel.position = CGPoint(x: 4, y: CGRectGetMaxY(self.frame) - levelLabel.fontSize - 4)
        addChild(levelLabel)
        
        currentCharacterLabel.horizontalAlignmentMode = .Center
        currentCharacterLabel.fontSize = 14
        currentCharacterLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        addChild(currentCharacterLabel)
        
        BattleManager.sharedManager.delegate = self
        LevelManager.sharedManager.delegate = self
        
        LevelManager.sharedManager.addPlayer(Cleric())
        LevelManager.sharedManager.addPlayer(Neophyte())
        LevelManager.sharedManager.addPlayer(Knight())
        
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
                let battleManager = BattleManager.sharedManager
                if (node.character.isEnemy && pendingAbility == nil) {
                    pendingAbility = battleManager.activeCharacter?.abilities[0]
                }
                let success = battleManager.performAbilityForCharacter(pendingAbility, character: battleManager.activeCharacter, target: node.character)
                if success {
                    return
                }
            }
            
            // Process touches on ability nodes
            let touchedAbilityNodes = abilityNodes.filter {
                return CGRectContainsPoint($0.calculateAccumulatedFrame(), point)
            }
            
            if let node = touchedAbilityNodes.first {
                abilityNodes.forEach { $0.removeSelectedAction() }
                node.addSelectedAction()
                pendingAbility = node.ability
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
        BattleManager.sharedManager.moveToNextCharacter()
    }
    
    // MARK: BattleManagerDelegate
    func didStartBattle() {
        addNodesForLevel()
    }
    
    func didEndBattle() {
        if BattleManager.sharedManager.players.filter( { $0.health > 0 } ).count > 0 {
            // Player won
            LevelManager.sharedManager.moveToNextLevel()
        } else {
            // Enemy won
        }
    }
    
    func didStartTurn() {
        
    }
    
    func didEndTurn() {
        BattleManager.sharedManager.moveToNextCharacter()
    }
    
    func didMoveToActiveCharacter(activeCharacter: Character) {
        characterNodes.forEach { $0.removeSelectedAction() }
        pendingAbility = nil
        activeCharacter.node?.addSelectedAction()
        addAbilityNodesForCharacter(activeCharacter)
        currentCharacterLabel.text = activeCharacter.name
        
        if activeCharacter.isEnemy {
            // AI Logic
            let randomPlayer = BattleManager.sharedManager.players.randomElement()
            BattleManager.sharedManager.performAbilityForCharacter(activeCharacter.abilities.last, character: activeCharacter, target: randomPlayer)
        }
    }
    
    // MARK: Helpers
    private func addNodesForLevel() {
        characterNodes.forEach { $0.removeFromParent() }
        characterNodes.removeAll()
        
        for (i, enemy) in BattleManager.sharedManager.enemies.enumerate() {
            let node = CharacterNode(character: enemy)
            addCharacterNode(node, isEnemy: true, index: i)
        }
        
        for (i, player) in BattleManager.sharedManager.players.enumerate() {
            if player.health > 0 {
                let node = CharacterNode(character: player)
                addCharacterNode(node, isEnemy: false, index: i)
            }
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
