//
//  IntroScene.swift
//  missleMadness
//
//  Created by Paul Defilippi on 4/9/17.
//  Copyright © 2017 Paul Defilippi. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class IntroScene: SKScene {
    
    var isPhone = true
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    let instructionLabel = SKLabelNode(fontNamed: "BM germar")
    var introImage:SKSpriteNode?
    
    
    
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
        
        let tex: SKTexture = SKTexture(imageNamed: "intro_screen")
        let theSize: CGSize = CGSize(width: screenWidth, height: screenHeight)
        
        
        
        introImage = SKSpriteNode(texture: tex, color: SKColor.clear, size: theSize)
        self.addChild(introImage!)
        introImage!.position = CGPoint(x: 0, y: screenHeight / 2)
        
        createInstructionLabel()
        
    }
    
    func createInstructionLabel() {
        
        instructionLabel.horizontalAlignmentMode = .center
        instructionLabel.verticalAlignmentMode = .center
        instructionLabel.fontColor = SKColor.white
        instructionLabel.text = "Touch to Begin Game!"
        instructionLabel.zPosition = 1
        addChild(instructionLabel)
        
        if isPhone == true {
            
            instructionLabel.position = CGPoint(x: 0, y: screenHeight * 0.15)
            instructionLabel.fontSize = 30
            
        } else {
            
            instructionLabel.position = CGPoint(x: 0, y: screenHeight * 0.20)
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
        
        let transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 1.0)
        let scene = GameScene(size: self.scene!.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill

        self.scene!.view!.presentScene(scene, transition: transition)
        
        
        /*
        let fadeDown = SKAction.fadeAlpha(to: 0, duration: 0.2)
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([fadeDown, remove])
        
        instructionLabel.run(seq)
        introImage!.run(seq)
        */
        
        
        
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

