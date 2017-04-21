//
//  Base.swift
//  missleMadness
//
//  Created by Paul Defilippi on 4/21/17.
//  Copyright © 2017 Paul Defilippi. All rights reserved.
//

import Foundation
import SpriteKit

class Base: SKSpriteNode {
    
    var baseName: String = ""
    var hitCount = 1
    var maxDamage = 4
    var alreadyDestroyed = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed: String) {
        
        baseName = imageNamed
        
        let imageTexture = SKTexture(imageNamed: baseName + String(hitCount))
        super.init(texture: imageTexture, color: SKColor.clear, size: imageTexture.size())
        
        let body = SKPhysicsBody(circleOfRadius: imageTexture.size().width / 2.25, center: CGPoint(x: 0, y: 15))
        
        body.isDynamic = false
        body.affectedByGravity = false
        body.allowsRotation = false
        
        body.categoryBitMask = BodyType.base.rawValue
        body.contactTestBitMask = BodyType.enemyMissile.rawValue | BodyType.bullet.rawValue | BodyType.enemyBomb.rawValue
        body.collisionBitMask = BodyType.enemyMissile.rawValue | BodyType.enemyBomb.rawValue
        self.physicsBody = body
        self.name = "base"
        
        
    }
    
    func hit(_ damageAmount:Int) {
        
        hitCount = hitCount + damageAmount
        
        
        if ( hitCount <= (maxDamage - 1)) {
            
            self.texture = SKTexture(imageNamed: baseName + String(hitCount) )
            
            switch(hitCount) {
                
            case 2:
                addParticles(5)
            case 3:
                addParticles(10)
                
            default:
                addParticles(15)
                break
                
            }
            
            
            
        } else if hitCount >= maxDamage && alreadyDestroyed == false {
            
            self.texture = SKTexture(imageNamed: baseName + String(maxDamage))
            alreadyDestroyed = true
            
            addParticles(40)
            
        }
        
            
            
        }
        
        func addParticles(_ num: Int) {
            
            let glassEmitter = SKEmitterNode(fileNamed: "Glass")
            
            glassEmitter!.name = "Glass"
            glassEmitter!.zPosition = -1
            glassEmitter!.targetNode = self
            glassEmitter!.numParticlesToEmit = num
            glassEmitter!.position = CGPoint(x: 0, y: 25)
            
            self.addChild(glassEmitter!)
            
            
            
            
            
        }
        
        func revive() {
            
            alreadyDestroyed = false
            hitCount = 1
            self.texture = SKTexture(imageNamed: baseName + String(hitCount))
            
            
        }
        
        
        
    }









