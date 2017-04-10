//
//  GameScene.swift
//  missleMadness
//
//  Created by Paul Defilippi on 4/6/17.
//  Copyright © 2017 Paul Defilippi. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var isPhone = true
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    let instructionLabel = SKLabelNode(fontNamed: "BM germar")

    override func didMove(to view: SKView) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            isPhone = false
            
        } else {
            
            isPhone = true
        }
        
        screenWidth = self.view!.bounds.width
        screenHeight = self.view!.bounds.height
        
        print(screenWidth)
        print(screenHeight)
        
        self.backgroundColor = SKColor.black
        self.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        createInstructionLabel()
        
    }
    
    func createInstructionLabel() {
        
        instructionLabel.horizontalAlignmentMode = .center
        instructionLabel.verticalAlignmentMode = .center
        instructionLabel.fontColor = SKColor.white
        instructionLabel.text = "Rotate Fingers to Swing Turret"
        instructionLabel.zPosition = 1
        addChild(instructionLabel)

        if isPhone == true {
            
            instructionLabel.position = CGPoint(x: 0, y: screenHeight / 2)
            instructionLabel.fontSize = 30
            
        } else {
            
            instructionLabel.position = CGPoint(x: 0, y: screenHeight / 2)
            instructionLabel.fontSize = 40
            
        }
        
        // Lets introduce some SKActions
        
        let wait = SKAction.wait(forDuration: 0.5)
        let fadeDown = SKAction.fadeAlpha(to: 0, duration: 0.4)
        let fadeUp = SKAction.fadeAlpha(to: 1, duration: 0.4)
        let seq = SKAction.sequence([wait, fadeDown, fadeUp])
        let rep = SKAction.repeatForever(seq)
        instructionLabel.run(rep)
    }
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
    }
        

    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
