//
//  ViewController.swift
//  TestDrowing
//
//  Created by Александр Вань on 25.05.2021.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var distanceView: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet var sceneView: ARSCNView!
    
    let settings = settingsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceSlider.value = settings.getDistance()
        distanceSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        addCursor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    @IBOutlet weak var drowButton: UIButton!
    
    var pos = 0.0
    func addDrawing(){
        let sphereNode = SCNNode.init()
        let sphereGeometry = SCNSphere.init(radius: CGFloat(settings.getSize()))
        sphereGeometry.materials.first?.diffuse.contents = settings.getColor()
        sphereNode.geometry = sphereGeometry
        sphereNode.position = SCNVector3.init(0, 0, -(settings.getDistance()))
        
        
        self.sceneView.pointOfView?.addChildNode(sphereNode)


        let spherePosition = sphereNode.worldPosition
        sphereNode.removeFromParentNode()
        sphereNode.worldPosition = spherePosition
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
            
    }
    let cursorNode = SCNNode.init()
    func addCursor(){
        let cursorGeometry = SCNSphere.init(radius: CGFloat(settings.getSize()))
        cursorGeometry.materials.first?.diffuse.contents = UIImage.init(named: "ImageX")
        cursorNode.geometry = cursorGeometry
        cursorNode.position = SCNVector3.init(0, 0, -(settings.getDistance()))
        sceneView.scene.rootNode.addChildNode(cursorNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if drowButton.isHighlighted{
            addDrawing()
            
        }
        distanceView.text = String(format: "%.1f", settings.getDistance())
        let testNode = SCNNode.init()
        testNode.position = SCNVector3.init(0, 0, -(settings.getDistance()))
        self.sceneView.pointOfView?.addChildNode(testNode)
        
        let testPosition = testNode.worldPosition
        testNode.removeFromParentNode()
        testNode.worldPosition = testPosition
        self.sceneView.scene.rootNode.addChildNode(testNode)
        
        cursorNode.position = testNode.position
        cursorNode.geometry = SCNSphere.init(radius: CGFloat(settings.getSize()))
        cursorNode.geometry?.materials.first?.diffuse.contents = UIImage.init(named: "ImageX")
//        print(sceneView.scene.rootNode.childNodes.count)
        testNode.removeFromParentNode()
        
    }
   
    
    @IBAction func resetButton(_ sender: UIButton) {
        
        let nodeCount = sceneView.scene.rootNode.childNodes.count
        
        var i = 0
        while true{
            i = i + 1
            sceneView.scene.rootNode.childNodes.last?.removeFromParentNode()
            if i == nodeCount{
                break
            }
        }
        addCursor()
    }
    
    @IBAction func plusButton(_ sender: UIButton) {
        if settings.getSize() < 0.5 {
            settings.setSize(var: settings.getSize() + 0.01)
        }
    }
    @IBAction func minusButton(_ sender: UIButton) {
        if settings.getSize() > 0.02 {
            settings.setSize(var: settings.getSize() - 0.01)
        }
    }
    
    
    @IBAction func distanceSliderAction(_ sender: UISlider) {
        settings.setDistance(var: sender.value)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if settings.getTapSwitch(){
            guard let touch = touches.first else {
                return
            }
            let result = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
            guard let hitResult = result.last else {
                return
            }
            let hitMatrix = hitResult.worldTransform
            let matrix = SCNMatrix4(hitMatrix)
            let hitVector = SCNVector3.init(matrix.m41, matrix.m42, matrix.m43)
            print(hitVector.z)
            var dis: Float = 0.0
            if hitVector.z > 0 {
                dis = hitVector.z
            }else {
                dis = -hitVector.z
            }
            settings.setDistance(var: dis)
        }
        
    }
    var startPos = CGPoint.init(x: 0, y: 0)
    @IBAction func gestureRecognizer(_ sender: UIPanGestureRecognizer) {
        if settings.getTapSwitch(){
        if sender.state == .began{
            startPos = sender.location(in: sceneView)
           
        }
        if sender.state == .changed{
            let sphereNode = SCNNode.init()
            let sphereGeometry = SCNSphere.init(radius: CGFloat(settings.getSize()))
            sphereGeometry.materials.first?.diffuse.contents = settings.getColor()
            sphereNode.geometry = sphereGeometry
            var pos = sender.location(in: sceneView)
           
            if pos.x < 0 {
                pos.x += startPos.x
            }else{
                pos.x -= startPos.x
            }
            
            if pos.y < 0 {
                pos.y += startPos.y
            }else{
                pos.y -= startPos.y
            }
            
            sphereNode.position = SCNVector3.init(CGFloat(cursorNode.position.x) + (pos.x / 1000), CGFloat(cursorNode.position.y) + (pos.y / -1000), CGFloat(-(settings.getDistance())))
            self.sceneView.scene.rootNode.addChildNode(sphereNode)
            print(sphereNode.position)
            
        }
        if sender.state == .ended{
            startPos.x = 0
            startPos.y = 0
            
        }
        }
            
    }
    
    
    
    @IBAction func makeScreen(_ sender: UIButton) {
        var image = sceneView.snapshot()
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        //Звук
        let systemSoundID: SystemSoundID = 1108
        AudioServicesPlaySystemSound (systemSoundID)
        
        let nameApp = "ARDrawing"
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [nameApp ,image], applicationActivities: nil)

        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
//            UIActivity.ActivityType.postToWeibo,
//            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
//            UIActivity.ActivityType.addToReadingList,
//            UIActivity.ActivityType.postToFlickr,
//            UIActivity.ActivityType.postToVimeo,
//            UIActivity.ActivityType.postToTencentWeibo
        ]

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
