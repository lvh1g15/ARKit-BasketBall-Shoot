//
//  VirtualObject.swift
//  basketballthrow
//
//  Created by Landon Vago-Hughes on 07/10/2017.
//  Copyright © 2017 Landon Vago-Hughes. All rights reserved.
//

import Foundation
import SceneKit

class VirtualObjectNode: SCNNode {
    
    override init() {
        super.init()
        loadBasket()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func react() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.3
        SCNTransaction.completionBlock = {
            SCNTransaction.animationDuration = 0.15
            self.opacity = 1.0
        }
        self.opacity = 0.5
        SCNTransaction.commit()
    }
}

extension SCNNode {
    func loadBasket() {
        guard let scene = SCNScene(named: "model.scn", inDirectory: "art.scnassets") else {fatalError()}
        for child in scene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            addChildNode(child)
        }
    }
}

