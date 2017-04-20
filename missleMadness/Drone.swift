//
//  EnemyMissile.swift
//  missleMadness
//
//  Created by Paul Defilippi on 4/17/17.
//  Copyright © 2017 Paul Defilippi. All rights reserved.
//

import Foundation
import SpriteKit

class Drone: SKNode {
    
    var droneNode = SKSpriteNode()
    var droneAnimation:SKAction?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
    }
    
    func createDrone() {
        
        droneNode = SKSpriteNode(imageNamed: "drone1")
        self.addChild(droneNode)
        
        
        self.name = "drone"
        
        setUpAnimation()
    }
    
    func setUpAnimation() {
        
        var array = [String]()
        
        for i in 1...20 {
            
            let nameString = String(format: "drone%i", i)
            array.append(nameString)
            
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        for i in 0..<array.count {
            
            let texture = SKTexture(imageNamed: array[i])
            
            atlasTextures.insert(texture, at: i)
            
        }
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1.0 / 30, resize: true, restore: false)
        droneAnimation = SKAction.repeatForever(atlasAnimation)
        
        droneNode.run(droneAnimation!, withKey: "animation")
        
        
    }
    
    
    
    
    
    
    
}
