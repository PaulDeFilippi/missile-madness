//
//  EnemyMissile.swift
//  missleMadness
//
//  Created by Paul Defilippi on 4/17/17.
//  Copyright © 2017 Paul Defilippi. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyMissile: SKNode {
    
    var missileNode = SKSpriteNode()
    var missileAnimation:SKAction?
    
    let fireEmitter = SKEmitterNode(fileNamed: "FIreParticles")
    
    var hitsToKill = 2
    var hitCount = 0
    var damagePoints = 4
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
    }
    
    func createMissile(theImage: String) {
        
        missileNode = SKSpriteNode(imageNamed: "enemyMissile")
        self.addChild(missileNode)
        missileNode.zPosition = 1
        
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: missileNode.size.width / 2.25, center:CGPoint(x: 0, y: 0))
        body.isDynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        
        body.categoryBitMask = BodyType.enemyMissile.rawValue
        body.contactTestBitMask = BodyType.ground.rawValue | BodyType.bullet.rawValue | BodyType.base.rawValue | BodyType.playerBase.rawValue
        
        
        
        
        self.physicsBody = body
        
        self.name = "enemyMissile"
        
        setUpAnimation()
        addParticles()
    }
    
    func setUpAnimation() {
        
        var array = [String]()
        
        for i in 1...10 {
            
            let nameString = String(format: "enemyMissile%i", i)
            array.append(nameString)
            
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        for i in 0..<array.count {
            
            let texture = SKTexture(imageNamed: array[i])
            
            atlasTextures.insert(texture, at: i)
            
        }
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1.0 / 20, resize: true, restore: false)
        missileAnimation = SKAction.repeatForever(atlasAnimation)
        
        missileNode.run(missileAnimation!, withKey: "animation")
        
        
    }
    
    func addParticles() {
        fireEmitter!.name = "fireEmitter"
        fireEmitter!.zPosition = -2
        fireEmitter!.targetNode = self
        fireEmitter!.particleLifetime = 10
        //fireEmitter!.numParticlesToEmit = 200
        
        self.addChild(fireEmitter!)
        
    }
    
    func hit() -> Bool {
        
        hitCount += 1
        
        if hitCount == hitsToKill {
            
            self.removeFromParent()
            return true
            
        
        
        } else {
            damagePoints = 1
            
            fireEmitter!.numParticlesToEmit = 10
            
            missileNode.removeAction(forKey: "animation")
            return false
        }
    
    }
    
    
    func destroy() {
        
        self.name = "removeNode"
        
        
        
    }
    
    
    
    
    
    
    
}
