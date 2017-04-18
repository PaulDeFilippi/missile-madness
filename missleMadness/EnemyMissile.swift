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
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
    }
    
    func createMissile(theImage: String) {
        
        print("missile was created")
        
        missileNode = SKSpriteNode(imageNamed: "enemyMissile")
        self.addChild(missileNode)
        
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: missileNode.size.width / 2.25, center:CGPoint(x: 0, y: 0))
        body.isDynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        
        body.categoryBitMask = BodyType.enemyMissile.rawValue
        body.contactTestBitMask = BodyType.ground.rawValue | BodyType.bullet.rawValue | BodyType.base.rawValue | BodyType.playerBase.rawValue
        
        
        self.physicsBody = body
        
        self.name = "enemyMissile"
    }
    
    
    
    
    
    
    
}
