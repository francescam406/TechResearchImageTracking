//
//  ViewController.swift
//  TechResearch
//
//  Created by Francesca Mangino on 02/04/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var antNode: SCNNode?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        let antScene = SCNScene(named: "art.scnassets/ant.scn")
        antNode = antScene?.rootNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "poster", bundle: Bundle.main){
            
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.1)
            plane.cornerRadius = 0.005
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            if let shapeNode = antNode {
                node.addChildNode(shapeNode)
            }else{print("Errore")}
        }
        return node
    }
    
}
