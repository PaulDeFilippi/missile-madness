//
//  GameScene.swift
//  missleMadness
//
//  Created by Paul Defilippi on 4/6/17.
//  Copyright © 2017 Paul Defilippi. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

enum BodyType:UInt32 {
    
    case playerBase = 1
    case base = 2
    case bullet = 4
    case enemyMissile = 8
    case enemy = 16
    case ground = 32
    case enemyBomb = 64
    
}

class GameScene: SKScene {
    
    var isPhone = true
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    let instructionLabel = SKLabelNode(fontNamed: "BM germar")
    
    let playerBase = SKSpriteNode(imageNamed: "playerBase")
    let turret = SKSpriteNode(imageNamed: "turret")
    let target = SKSpriteNode(imageNamed: "target")
    var ground = SKSpriteNode()
    
    let loopingBG = SKSpriteNode(imageNamed: "stars")
    let loopingBG2 = SKSpriteNode(imageNamed: "stars")
    let moon = SKSpriteNode(imageNamed: "moon")
    
    let length:CGFloat = 200
    var theRotation:CGFloat = 0
    var offSet:CGFloat = 0
    
    let rotateRec = UIRotationGestureRecognizer()
    let tapRec = UITapGestureRecognizer()

    override func didMove(to view: SKView) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            isPhone = false
            
        } else {
            
            isPhone = true
        }
        
        //important - this is how we adjust overall gravity
        physicsWorld.gravity = CGVector(dx: 0, dy:  -0.1)
        
        screenWidth = self.view!.bounds.width
        screenHeight = self.view!.bounds.height
        
        //rotateRec.addTarget(self, action: #selector(("rotatedView:")))
        
        rotateRec.addTarget(self, action: #selector(GameScene.rotatedView(_:)))
        self.view!.addGestureRecognizer(rotateRec)
        
        tapRec.addTarget(self, action: #selector(GameScene.tappedVIew))
        tapRec.numberOfTouchesRequired = 1
        tapRec.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapRec)
        
        self.backgroundColor = SKColor.black
        self.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        createGround()
        addPlayer()
        
        setUpbackground()
        
        createInstructionLabel()
        
    }
    
    func setUpbackground() {
        
        addChild(moon)
        addChild(loopingBG)
        addChild(loopingBG2)
        
        moon.zPosition = -199
        loopingBG.zPosition = -200
        loopingBG2.zPosition = -200
        
        loopingBG.position = CGPoint(x: 0, y: loopingBG.size.height / 2)
        loopingBG2.position = CGPoint(x: loopingBG2.size.width, y: loopingBG.size.height / 2)
        moon.position = CGPoint(x: (screenWidth / 2) + moon.size.width, y: screenHeight / 2)
        
        startLoopingBackground()
        
    }
    
    func startLoopingBackground() {
        
        let move = SKAction.moveBy(x: -loopingBG.size.width, y: 0, duration: 80)
        let moveBack = SKAction.moveBy(x: loopingBG.size.width, y: 0, duration: 0)
        let seq = SKAction.sequence([move, moveBack])
        let rep = SKAction.repeatForever(seq)
        
        loopingBG.run(rep)
        loopingBG2.run(rep)
        
        let moveMoon = SKAction.moveBy(x: -screenWidth * 1.3 , y: 0, duration: 60)
        let moveMoonBack = SKAction.moveBy(x: -screenWidth * 1.3 , y: 0, duration: 0)
        let wait = SKAction.wait(forDuration: 10)
        
        let seqMoon = SKAction.sequence([moveMoon, wait, moveMoonBack])
        let repeatMoon = SKAction.repeatForever(seqMoon)
        
        moon.run(repeatMoon)
        
        
        
    }
    
    func createGround() {
        
        let theSize = CGSize(width: screenWidth, height: 70)
        let tex = SKTexture(imageNamed: "rocky_ground")
        ground = SKSpriteNode(texture: tex, color: SKColor.clear, size: theSize)
        ground.physicsBody = SKPhysicsBody(rectangleOf: theSize)
        ground.physicsBody!.categoryBitMask = BodyType.ground.rawValue
        ground.physicsBody!.contactTestBitMask = BodyType.enemyMissile.rawValue | BodyType.enemyBomb.rawValue
        
        ground.physicsBody!.isDynamic = false
        
        addChild(ground)
        
        if isPhone == true {
            
            ground.position = CGPoint(x: 0, y: 0)
            
        } else {
            
            ground.position = CGPoint(x: 0, y: theSize.height / 2)
            
        }
        
        ground.zPosition = 500
        
        
    }
    
    func addPlayer() {
        
        addChild(playerBase)
        playerBase.zPosition = 100
        playerBase.position = CGPoint(x: 0, y: ground.position.y + (playerBase.size.height / 2))
        playerBase.physicsBody = SKPhysicsBody(circleOfRadius: playerBase.size.width / 2)
        playerBase.physicsBody!.categoryBitMask = BodyType.playerBase.rawValue
        playerBase.physicsBody!.isDynamic = false
        
        addChild(turret)
        turret.zPosition = 99
        turret.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        turret.position = CGPoint(x: 0, y: playerBase.position.y)
        
        addChild(target)
        target.zPosition = 98
        target.position = CGPoint(x: turret.position.x, y: turret.position.y + length)
        
        
    }
    
    func rotatedView(_ sender:UIRotationGestureRecognizer) {
        
        if sender.state == .changed {
            theRotation = CGFloat( -sender.rotation ) + offSet
            
            let maxRotation:CGFloat = 1.4
            
            if theRotation < -maxRotation {
                
                theRotation = -maxRotation
                
            } else if theRotation > maxRotation {
                
                theRotation = maxRotation
                
            }
            
            turret.zRotation = theRotation
            target.zRotation = theRotation
            
            let xDistance:CGFloat = sin(theRotation) * length
            let yDistance:CGFloat = cos(theRotation) * length
            
            target.position = CGPoint(x: turret.position.x - xDistance, y: turret.position.y + yDistance)
            
        }
        
        
        if sender.state == .ended {
            
            offSet = theRotation
            
        }
        
        print(theRotation)
        
    }
    
    func tappedVIew() {
        
        createBullet()
        
        rattle(playerBase)
        rattle(turret)
        
    }
    
    func rattle(_ node: SKSpriteNode) {
        
        let rattleUp = SKAction.moveBy(x: 0, y: 5, duration: 0.05)
        let rattleDown = SKAction.moveBy(x: 0, y: -5, duration: 0.05)
        let seq = SKAction.sequence(
         [ rattleUp, rattleDown] )
        let rep = SKAction.repeat(seq, count: 3)
        
        node.run(rep)
        
    }
    
    func createBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 3)
        bullet.physicsBody!.categoryBitMask = BodyType.bullet.rawValue
        bullet.zRotation = theRotation
        bullet.name = "bullet"
        
        let xDistance:CGFloat = sin(theRotation) * 70
        let yDistance:CGFloat = cos(theRotation) * 70
        
        bullet.position = CGPoint(x: turret.position.x - xDistance, y: turret.position.y + yDistance)
        
        addChild(bullet)
        
        let forceXDistance:CGFloat = sin(theRotation) * 250
        let forceYDistance:CGFloat = cos(theRotation) * 250
        
        let theForce = CGVector(dx: turret.position.x - forceXDistance, dy: turret.position.y + forceYDistance)
        
        bullet.physicsBody!.applyForce(theForce)
        
        createFiringParticles( bullet.position, force: theForce)
        
    }
    
    func createFiringParticles(_ location: CGPoint, force: CGVector) {
        
        let fireEmitter = SKEmitterNode(fileNamed: "FIreParticles")
        fireEmitter!.position = location
        fireEmitter!.numParticlesToEmit = 40
        fireEmitter!.zPosition = 1
        fireEmitter!.targetNode = self

        
        fireEmitter!.xAcceleration = force.dx
        fireEmitter!.yAcceleration = force.dy
        
        self.addChild(fireEmitter!)
        
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
        let seq = SKAction.sequence( [wait, fadeDown, fadeUp] )
        let repeated = SKAction.repeat(seq, count: 3)
        let remove = SKAction.removeFromParent()
        let seq2 = SKAction.sequence( [repeated, wait, remove] )
        instructionLabel.run(seq2)
    }
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
    }
        

    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
