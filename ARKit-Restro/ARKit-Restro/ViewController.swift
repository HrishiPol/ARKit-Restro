//
//  ViewController.swift
//  ARKit-Restro
//
//  Created by synerzip on 05/07/17.
//  Copyright © 2017 hrishikeshpol. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //        // Create a new scene
        //        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //
        //        // Set the scene to the view
        //        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
        sceneView.debugOptions = ARSCNDebugOptions.showWorldOrigin//ARSCNDebugOptionShowWorldOrigin
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        self.sceneView.showsStatistics = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        // Create a SceneKit plane to visualize the node using its position and extent.
        // Create the geometry and its materials
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        let spaceImage = UIImage(named: "space")
        let plainMaterial = SCNMaterial()
        plainMaterial.diffuse.contents = spaceImage
        plainMaterial.isDoubleSided = true
        
        plane.materials = [plainMaterial]
        
        // Create a node with the plane geometry we created
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        // SCNPlanes are vertically oriented in their local coordinate space.
        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        return planeNode
    }
    
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        print("Add node")
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let planeNode = createPlaneNode(anchor: planeAnchor)
        self.sceneView.showsStatistics = false
        // ARKit owns the node corresponding to the anchor, so make the plane a child node.
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        print("update node")
        
        // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        let planeNode = createPlaneNode(anchor: planeAnchor)
        
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
        print("Remove node")
        
        guard anchor is ARPlaneAnchor else { return }
        
        // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("didFailWithError")
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("sessionWasInterrupted")
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("sessionInterruptionEnded")
        
    }
}

