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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    
    var bgSoundPlayer: AVAudioPlayer?
    
    var gameIsActive = false
    
    var activeBase = CGPoint.zero
    
    var baseArray = [CGPoint]()
    
    var level1 = 1
    var score = 0
    var attacksLaunched = 0

    override func didMove(to view: SKView) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            isPhone = false
            
        } else {
            
            isPhone = true
        }
        
        //important - this is how we adjust overall gravity
        physicsWorld.gravity = CGVector(dx: 0, dy:  -0.1)
        physicsWorld.contactDelegate = self
        
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
        
        setLevelVars()
        
        createGround()
        addPlayer()
        
        setupBaseArray()
        addBases()
        
        setUpbackground()
        
        createInstructionLabel()
        
        playBackgroundSound("levelsound")
        
        startGame()
        
    }
    
    
    
    // MARK: ======== INITIAL SETUP
    
    
    func setLevelVars() {
        
        if level == 1 {
            
            physicsWorld.gravity = CGVector(dx: 0, dy:  -0.1)
            
            
            
        } else if level == 2 {
            
            physicsWorld.gravity = CGVector(dx: 0, dy:  -0.12)
            
            
            
        } else if level == 3 {
            
            physicsWorld.gravity = CGVector(dx: 0, dy:  -0.14)
            
            
            
        } else {
            
            physicsWorld.gravity = CGVector(dx: 0, dy:  -0.18)
            
            
            
        }
        
    }
    
    
    
    func setupBaseArray() {
        
        baseArray.append(CGPoint(x: screenWidth * 0.15, y: ground.position.y))
        baseArray.append(CGPoint(x: screenWidth * 0.3, y: ground.position.y))
        baseArray.append(CGPoint(x: screenWidth * 0.45, y: ground.position.y))
        baseArray.append(CGPoint(x: -screenWidth * 0.15, y: ground.position.y))
        baseArray.append(CGPoint(x: -screenWidth * 0.3, y: ground.position.y))
        baseArray.append(CGPoint(x: -screenWidth * 0.45, y: ground.position.y))
        
    }
    
    func addBases(){
        
        for item in baseArray {
            
            print(item)
            let base:Base = Base(imageNamed:"base")
            addChild(base)
            base.position = CGPoint(x: item.x , y: item.y + base.size.height / 2)
            
        }
        
        
        
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
        
        let move = SKAction.moveBy(x: -loopingBG.size.width, y: 0, duration: 90)
        let moveBack = SKAction.moveBy(x: loopingBG.size.width, y: 0, duration: 0)
        let seq = SKAction.sequence([move, moveBack])
        let rep = SKAction.repeatForever(seq)
        
        loopingBG.run(rep)
        loopingBG2.run(rep)
        
        let moveMoon = SKAction.moveBy(x: -screenWidth * 1.3 , y: 0, duration: 70)
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
    
    
    
    // MARK: ======== START GAME
    
    func startGame() {
        
        gameIsActive = true
        
        // start missiles coming down
        
        initiateEnemyMissile()
        
        
        // add particles / dots behind enemy missiles
        
        startDotLoop()
        
        
        // initiate drones flying accross
        
        
        initiateDrone()
        
        // check to see if game is over
        
        startGameOverTesting()
        
        
        // clear off screen objects
        
        clearOffScreenItems()
        
        
    }
    
    func startGameOverTesting() {
        
        let block = SKAction.run(gameOverTest)
        let wait = SKAction.wait(forDuration: 1)
        let seq = SKAction.sequence([ wait, block ])
        let rep = SKAction.repeatForever(seq)
        self.run(rep, withKey: "gameOverTest")
        
    }
    
    func gameOverTest() {
        
        var destroyedBases = 0
        self.enumerateChildNodes(withName: "base") {
            node, stop in
            
            if let someBase: Base = node as? Base {
                
                if someBase.alreadyDestroyed == true {
                    
                    destroyedBases += 1
                    
                } else {
                    
                    self.activeBase = someBase.position
                    
                }
            }
            
            /////////
            
            if destroyedBases == self.baseArray.count {
                
                self.gameOver()
                
            }
            
        }
        
    }
    
    
    
    func clearOffScreenItems() {
        
        clearBullet()
        clearEnemyMissiles()
        
        
        print("clearing items")
        
        let wait = SKAction.wait(forDuration: 1)
        let block = SKAction.run(clearOffScreenItems)
        let seq = SKAction.sequence([ wait, block ])
        self.run(seq, withKey: "clearAction")
        
    }
    
    func clearBullet() {
        
        self.enumerateChildNodes(withName: "bullet") {
            node, stop in
            
            if (node.position.x < -(self.screenWidth / 2)) {
                
                node.removeFromParent()
                
            } else if (node.position.x > (self.screenWidth / 2)) {
                
                node.removeFromParent()
            
            } else if (node.position.y > self.screenHeight) {
                
                node.removeFromParent()

            }
            
            // this code runs when we find a bullet
        }
        
    }
    
    func clearEnemyMissiles() {
        
        
        
    }
    
    
    // MARK: ======== CREATE ENEMY MISSILES
    
    func initiateEnemyMissile() {
        
        let wait = SKAction.wait(forDuration: 2)
        let block = SKAction.run(launchEnemyMissile)
        let seq = SKAction.sequence([ block, wait ])
        let rep = SKAction.repeatForever(seq)
        self.run(rep, withKey: "enemyLaunchAction")
        
    }
    
    func launchEnemyMissile() {
        
        createExplosion(atLocation: CGPoint(x: 0, y: screenHeight / 2), image: "explosion")
        
        let missile:EnemyMissile = EnemyMissile()
        missile.createMissile(theImage: "enemyMissile")
        addChild(missile)
        
        let randomX = arc4random_uniform(UInt32(screenWidth))
        missile.position = CGPoint(x: CGFloat(randomX)  - (screenWidth / 2), y: screenHeight + 50)
        
        let randomVecX = arc4random_uniform( 20 )
        
        let vecX:CGFloat = CGFloat(randomVecX) / 10
        
        
        if ( missile.position.x < 0) {
            
            missile.physicsBody?.applyImpulse( CGVector(dx: vecX, dy: 0) )
            
        } else {
            
            missile.physicsBody?.applyImpulse( CGVector(dx: -vecX, dy: 0) )
            
        }
        
        
    }
    
    func startDotLoop() {
        
        let block = SKAction.run(addDot)
        let wait = SKAction.wait(forDuration: 1/60)
        let seq = SKAction.sequence([ block, wait ])
        let rep = SKAction.repeatForever(seq)
        self.run(rep, withKey: "dotAction")
        
        
    }
    
    func addDot() {
        
        self.enumerateChildNodes(withName: "enemyMissile") {
            node, stop in
            
            let dot = SKSpriteNode(imageNamed: "dot")
            dot.position = node.position
            self.addChild(dot)
            dot.zPosition = -1
            dot.xScale = 0.3
            dot.yScale = 0.3
            
            let fade = SKAction.fadeAlpha(to: 0.0, duration: 3)
            let grow = SKAction.scale(to: 3.0, duration: 2)
            let color = SKAction.colorize(with: SKColor.orange, colorBlendFactor: 1, duration: 3)
            let group = SKAction.group([fade, grow, color])
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([group ,remove])
            dot.run(seq)
            
        }
        
    }
    
    
    
    // MARK: ======== CREATE DRONE
    
    
    
    func initiateDrone() {
        
        let wait = SKAction.wait(forDuration: 10)
        let block = SKAction.run(launchDrone)
        let seq = SKAction.sequence([ wait, block ])
        self.run(seq)
        
    }
    
    func launchDrone() {
        
        let theDrone:Drone = Drone()
        theDrone.createDrone()
        addChild(theDrone)
        theDrone.position = CGPoint(x: (screenWidth / 2) + theDrone.droneNode.size.width, y: screenHeight * 0.8)
        
        let move = SKAction.moveBy(x: -(screenWidth + (theDrone.droneNode.size.width * 2)), y: 0, duration: 10)
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([move, remove])
        theDrone.run(seq)
        
        // drop bombs
        
        let randomDrop = arc4random_uniform(6)
        let waitToDrop = SKAction.wait(forDuration: CFTimeInterval(randomDrop + 2))
        let blockDrop = SKAction.run(dropBombFromDrone)
        let dropSequence = SKAction.sequence([waitToDrop, blockDrop])
        self.run(dropSequence, withKey: "dropBombAction")
        
        // launch next drone
        
        let randomTime = arc4random_uniform(20)
        let wait = SKAction.wait(forDuration: CFTimeInterval(randomTime) + 7)
        let block = SKAction.run(launchDrone)
        let seq2 = SKAction.sequence([wait, block])
        self.run(seq2, withKey: "droneAction")
        
    }
    
    func dropBombFromDrone() {
        
        var dronePosition = CGPoint.zero
        
        self.enumerateChildNodes(withName: "drone") {
            node, stop in
            
            dronePosition = node.position
            
        }
        
        let droneBomb = SKSpriteNode(imageNamed: "droneBomb")
        droneBomb.name = "droneBomb"
        droneBomb.position = CGPoint(x: dronePosition.x, y: dronePosition.y - 45)
        self.addChild(droneBomb)
        
        droneBomb.physicsBody = SKPhysicsBody(circleOfRadius: droneBomb.size.width / 3)
        droneBomb.physicsBody!.categoryBitMask = BodyType.enemyBomb.rawValue
        droneBomb.physicsBody!.contactTestBitMask = BodyType.base.rawValue | BodyType.bullet.rawValue
        droneBomb.physicsBody!.isDynamic = true
        droneBomb.physicsBody!.affectedByGravity = false
        droneBomb.physicsBody!.allowsRotation = false
        
        let scaleY = SKAction.scaleX(by: 1, y: 1.5, duration: 0.5)
        droneBomb.run(scaleY)
        
        let move = SKAction.move(to: activeBase, duration: 4)
        droneBomb.run(move)
        
    }
    
    
    
    
    // MARK: ======== ROTATE GESTURE
    
    
    
    
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
        playSound(name: "gun1.caf")
        
        let xDistance:CGFloat = sin(theRotation) * 70
        let yDistance:CGFloat = cos(theRotation) * 70
        
        bullet.position = CGPoint(x: turret.position.x - xDistance, y: turret.position.y + yDistance)
        
        addChild(bullet)
        
        let forceXDistance:CGFloat = sin(theRotation) * 250
        let forceYDistance:CGFloat = cos(theRotation) * 250
        
        let theForce = CGVector(dx: turret.position.x - forceXDistance, dy: turret.position.y + forceYDistance)
        
        bullet.physicsBody!.applyForce(theForce)
        
        createFiringParticles(bullet.position, force: theForce)
        
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
    
    
    
    // MARK: ======== TAP TO SOUNDS
    
    func playBackgroundSound(_ name: String) {
        
        if bgSoundPlayer != nil {
            
            bgSoundPlayer!.stop()
            bgSoundPlayer = nil
            
        }
        
        let fileURL = Bundle.main.url(forResource: name, withExtension: "mp3")
        
        do {
            bgSoundPlayer = try AVAudioPlayer(contentsOf: fileURL!)
        } catch {
            bgSoundPlayer = nil
        }
        
        bgSoundPlayer!.volume = 0.5 //half volume
        bgSoundPlayer!.numberOfLoops = -1
        bgSoundPlayer!.prepareToPlay()
        bgSoundPlayer!.play()
        
    }
    
    func playSound(name: String) {
        
        let theSound = SKAction.playSoundFileNamed(name, waitForCompletion: false)
        self.run(theSound)
        
    }
    
    
    
        // MARK: ======== EXPLOSION
    
    func createExplosion(atLocation: CGPoint, image: String) {
        
        let explosion = SKSpriteNode(imageNamed: image)
        explosion.position = atLocation
        self.addChild(explosion)
        explosion.zPosition = 1
        explosion.xScale = 0.1
        explosion.yScale = explosion.xScale
        
        let grow = SKAction.scale(to: 1, duration: 0.5)
        grow.timingMode = .easeOut
        let color = SKAction.colorize(with: SKColor.white, colorBlendFactor: 0.5, duration: 0.5)
        let group = SKAction.group([grow, color])
        
        let fade = SKAction.fadeAlpha(to: 0, duration: 1)
        fade.timingMode = .easeIn
        let shrink = SKAction.scale(to: 0.8, duration: 1)
        let group2 = SKAction.group([fade, shrink])
        
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([group, group2, remove])
        explosion.run(seq)
        
    }
    
    
    
    
    // MARK: ======== CONTACT LISTENER
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == BodyType.enemyMissile.rawValue && contact.bodyB.categoryBitMask == BodyType.bullet.rawValue {
            
            if let missile = contact.bodyA.node! as? EnemyMissile {
                
                enemyMissileAndBullet(theMissile: missile)
            
            }
            
            contact.bodyB.node?.name = "removeNode"
            
        } else if contact.bodyA.categoryBitMask == BodyType.bullet.rawValue && contact.bodyB.categoryBitMask == BodyType.enemyMissile.rawValue {
            
            if let missile = contact.bodyB.node! as? EnemyMissile {
                
                enemyMissileAndBullet(theMissile: missile)
                
            }
            
            contact.bodyA.node?.name = "removeNode"
            
        } else if contact.bodyA.categoryBitMask == BodyType.bullet.rawValue && contact.bodyB.categoryBitMask == BodyType.enemyBomb.rawValue {
            
            createExplosion(atLocation: contact.bodyB.node!.position, image: "explosion2")
            
            contact.bodyB.node?.name = "removeNode"
            contact.bodyA.node?.name = "removeNode"
            
            playSound(name: "loud_bomb.caf")
            

        } else if contact.bodyA.categoryBitMask == BodyType.enemyBomb.rawValue && contact.bodyB.categoryBitMask == BodyType.bullet.rawValue {
            
            createExplosion(atLocation: contact.bodyA.node!.position, image: "explosion2")
            
            contact.bodyB.node?.name = "removeNode"
            contact.bodyA.node?.name = "removeNode"
            
            playSound(name: "loud_bomb.caf")
            
            
        } else if contact.bodyA.categoryBitMask == BodyType.base.rawValue && contact.bodyB.categoryBitMask == BodyType.bullet.rawValue {
            
            contact.bodyB.node?.name = "removeNode"
            
        } else if contact.bodyA.categoryBitMask == BodyType.bullet.rawValue && contact.bodyB.categoryBitMask == BodyType.base.rawValue {
            
            contact.bodyA.node?.name = "removeNode"
            
        } else if contact.bodyA.categoryBitMask == BodyType.enemyMissile.rawValue && contact.bodyB.categoryBitMask == BodyType.playerBase.rawValue {
            
            if let missile = contact.bodyA.node! as? EnemyMissile {
                
                createExplosion(atLocation: missile.position, image: "explosion")
                missile.destroy()
                
            }
            
            // subtract main player health
            
            playSound(name: "explosion2.caf")
            

        } else if contact.bodyA.categoryBitMask == BodyType.playerBase.rawValue && contact.bodyB.categoryBitMask == BodyType.enemyMissile.rawValue {
            
            if let missile = contact.bodyB.node! as? EnemyMissile {
                
                createExplosion(atLocation: missile.position, image: "explosion")
                missile.destroy()
                
            }
            
            // subtract main player health
            
            playSound(name: "explosion2.caf")
            
        } else if contact.bodyA.categoryBitMask == BodyType.enemyMissile.rawValue && contact.bodyB.categoryBitMask == BodyType.ground.rawValue {
            
            if let missile = contact.bodyB.node! as? EnemyMissile {
                
                createExplosion(atLocation: missile.position, image: "explosion")
                missile.destroy()
                
            }
            
            playSound(name: "explosion2.caf")
            
        } else if contact.bodyA.categoryBitMask == BodyType.ground.rawValue && contact.bodyB.categoryBitMask == BodyType.enemyMissile.rawValue {
            
            if let missile = contact.bodyB.node! as? EnemyMissile {
                
                createExplosion(atLocation: missile.position, image: "explosion")
                missile.destroy()
                
            }
            
            playSound(name: "explosion2.caf")
            
        } else if contact.bodyA.categoryBitMask == BodyType.enemyMissile.rawValue && contact.bodyB.categoryBitMask == BodyType.base.rawValue {
            
            if let missile = contact.bodyA.node! as? EnemyMissile {
                
                if let base = contact.bodyB.node! as? Base {
                    
                    base.hit(missile.damagePoints)
                    
                }
                
                createExplosion(atLocation: missile.position, image: "explosion")
                missile.destroy()
                
            }
            
            playSound(name: "explosion2.caf")
            
        } else if contact.bodyA.categoryBitMask == BodyType.base.rawValue && contact.bodyB.categoryBitMask == BodyType.enemyMissile.rawValue {
            
            if let missile = contact.bodyB.node! as? EnemyMissile {
                
                if let base = contact.bodyA.node! as? Base {
                    
                    base.hit(missile.damagePoints)
                    
                }
                
                createExplosion(atLocation: missile.position, image: "explosion")
                missile.destroy()
                
            }
            
            playSound(name: "explosion2.caf")
            
        } else if contact.bodyA.categoryBitMask == BodyType.enemyBomb.rawValue && contact.bodyB.categoryBitMask == BodyType.base.rawValue {
            
            if let base = contact.bodyB.node! as? Base {
                
                    
                base.hit(base.maxDamage)
                    
                }
                
                createExplosion(atLocation: contact.bodyA.node!.position, image: "explosion2")
                contact.bodyA.node?.name = "removeNode"
            
                playSound(name: "explosion2.caf")
        
        } else if contact.bodyA.categoryBitMask == BodyType.base.rawValue && contact.bodyB.categoryBitMask == BodyType.enemyBomb.rawValue {
            
            if let base = contact.bodyA.node! as? Base {
                    
                    base.hit(base.maxDamage)
                    
                }
                
                createExplosion(atLocation: contact.bodyB.node!.position, image: "explosion2")
                contact.bodyA.node?.name = "removeNode"
                
                playSound(name: "explosion2.caf")
            
        }
        
    }
    
    func enemyMissileAndBullet(theMissile: EnemyMissile) {
        
        let thePoint: CGPoint = theMissile.position
        
        if theMissile.hit() == true {
            
            createExplosion(atLocation: thePoint, image: "explosion")
            playSound(name: "explosion1.caf")
            
        } else {
            
            playSound(name: "ricochet.caf")
            
        }
        
        
        
    }
    
    
    
    
    // MARK: ======== GAME OVER
    
    func gameOver() {
        
        if gameIsActive == true {
            
            gameIsActive = false
            
            explodeAllMissiles()
            stopGameActions()
            moveDownBases()
            
            let wait = SKAction.wait(forDuration: 4)
            let block = SKAction.run(restartGame)
            let seq = SKAction.sequence([wait, block])
            self.run(seq)
            
        }
        
        
    }
    
    func restartGame() {
        
        if gameIsActive == false {
            
            level1 = 1
            score = 0
            attacksLaunched = 0
            
            setLevelVars()
            
            startGame()
            
        }
        
    }
    
    func moveDownBases() {
        
        playSound(name: "restoreHealth.caf")
        
        self.enumerateChildNodes(withName: "base") {
            
            node, stop in
            
            if let someBase: Base = node as? Base {
                
                let wait = SKAction.wait(forDuration: 2)
                let moveDown = SKAction.moveBy(x: 0, y: -200, duration: 3)
                let block = SKAction.run(someBase.revive)
                let moveUp = SKAction.moveBy(x: 0, y: 200, duration: 1)
                let seq = SKAction.sequence([wait, moveDown, block, moveUp])
                someBase.run(seq)
                
            }
            
        }
        
    }
    
    func stopGameActions() {
        
        self.removeAction(forKey: "gameOverTest")
        self.removeAction(forKey: "droneAction")
        self.removeAction(forKey: "enemyLaunchAction")
        self.removeAction(forKey: "dotAction")
        self.removeAction(forKey: "clearAction")
        self.removeAction(forKey: "dropBombAction")
        
    }
    
    func explodeAllMissiles() {
        
        playSound(name: "explosion1.caf")
        
        self.enumerateChildNodes(withName: "enemyMissile") {
            
            node, stop in
            
            if let enemyMissile: EnemyMissile = node as? EnemyMissile {
                
                self.createExplosion(atLocation: enemyMissile.position, image: "explosion")
                enemyMissile.destroy()
            }
        }
        
        self.enumerateChildNodes(withName: "enemyMissile") {
            
            node, stop in
            
                self.createExplosion(atLocation: node.position, image: "explosion2")
                node.name = "removeNode"
        }
        
    }
    
    override func didSimulatePhysics() {
        self.enumerateChildNodes(withName: "removeNode") {
            
            node, stop in
            
            node.removeFromParent()
        }
    }
    
    
}








