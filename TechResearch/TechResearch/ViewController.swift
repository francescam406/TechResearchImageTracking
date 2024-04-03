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
   
    var treeNode: SCNNode?
    var eyeballNode : SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
       let treeScene = SCNScene(named: "art.scnassets/tree.scn")
       let eyeballScene = SCNScene(named: "art.scnassets./eyeball.scn")
        treeNode = treeScene?.rootNode
        eyeballNode = eyeballScene?.rootNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Illustrations", bundle: Bundle.main){
            
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 2
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
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            plane.cornerRadius = 0.005
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            var shapeNode: SCNNode?
            switch imageAnchor.referenceImage.name{
            case cardType.denari.rawValue :
            shapeNode = treeNode
            case cardType.spade.rawValue :
            shapeNode = eyeballNode
            default :
                break
            }
         
            guard let shape = shapeNode else {return nil}
            node.addChildNode(shape)
        }
        return node
    }
    enum cardType : String {
    case denari = "denari"
    case spade = "spade"
    }
}
