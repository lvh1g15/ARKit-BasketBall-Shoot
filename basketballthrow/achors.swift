//
//  achors.swift
//  basketballthrow
//
//  Created by Landon Vago-Hughes on 07/10/2017.
//  Copyright © 2017 Landon Vago-Hughes. All rights reserved.
//

import Foundation
import SceneKit

//extension ViewController {
//
//    func addPlaneNode(on node: SCNNode, color: UIColor) {
//
//        let geometry = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
//        geometry.materials.first?.diffuse.contents = color
//
//        let planeNode = SCNNode(geometry: geometry)
//        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
//
//        DispatchQueue.main.async(execute: {
//            node.addChildNode(planeNode)
//        })
//    }
//
//    func updatePlaneNode(on node: SCNNode) {
//
//        DispatchQueue.main.async(execute: {
//            for childNode in node.childNodes {
//                guard let plane = childNode.geometry as? SCNPlane else {continue}
//                guard !PlaneSizeEqualToExtent(plane: plane, extent: self.extent) else {continue}
//
//                //                print("current plane size: (\(plane.width), \(plane.height))")
//                plane.width = CGFloat(self.extent.x)
//                plane.height = CGFloat(self.extent.z)
//                //                print("updated plane size: (\(plane.width), \(plane.height))")
//
//                break
//            }
//        })
//    }
//}

