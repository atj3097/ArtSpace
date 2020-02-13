//
//  ARViewController.swift
//  ArtSpaceDos
//
//  Created by Levi Davis on 2/6/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import ARKit

private enum AppState: Int16 {
    case lookingForSurface
    case pointToSurface
    case readyToFurnish
}

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    private var appState: AppState = .lookingForSurface
    
    //    MARK: - Instantiate UI Elements
    
    lazy var sceneView: ARSCNView = {
        let arView = ARSCNView()
        
        return arView
    }()
    
    lazy var resetButton: UIButton = {
        let resetButton = UIButton()
        resetButton.setTitle("RESET", for: .normal)
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        return resetButton
    }()
    
    //    MARK: - Lifecycle Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        constrainSubviews()
        initializeSceneView()
        initializeARSession()
    }
    
    //    MARK: - @Objc-Methods
    
    @objc private func resetButtonPressed(sender: UIButton) {
        resetARSession()
    }
    
    //    MARK: - Private Methods
    
    private func addSubviews() {
        view.addSubview(sceneView)
        sceneView.addSubview(resetButton)
    }
    
    private func constrainSubviews() {
        constrainSceneView()
        constrainResetButton()
    }
    
    private func constrainSceneView() {
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        //MARK: TO Do - Take safe area layout out??
        [sceneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         sceneView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         sceneView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         sceneView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)].forEach{$0.isActive = true}
        
    }
    
    private func constrainResetButton() {
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        [resetButton.bottomAnchor.constraint(equalTo: sceneView.bottomAnchor),
         resetButton.trailingAnchor.constraint(equalTo: sceneView.trailingAnchor),
         resetButton.heightAnchor.constraint(equalToConstant: 50),
         resetButton.widthAnchor.constraint(equalToConstant: 75)].forEach{$0.isActive = true}
    }
    
//    Initialize sceneView and ARSession
    
    private func initializeSceneView() {
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.showsStatistics = true
        sceneView.preferredFramesPerSecond = 60
        sceneView.antialiasingMode = .multisampling2X
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
//    Break configuration out into its own function, because it gets called more than once
    
    private func createARConfiguration() -> ARConfiguration {
        let config = ARWorldTrackingConfiguration()
        
        config.worldAlignment = .gravity
        config.planeDetection = [.horizontal, .vertical]
        config.isLightEstimationEnabled = true
        
        return config
    }
    
    private func initializeARSession() {
        guard ARWorldTrackingConfiguration.isSupported else {print("AR World Tracking Not Supported"); return}
        
        let config = createARConfiguration()
        sceneView.session.run(config)
    }
    
    private func resetARSession() {
        let config = createARConfiguration()
        sceneView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        appState = .lookingForSurface
    }
    
}

extension ARViewController {
    
//    MARK: - APP Status
    
//   This method gets called every second. Put things here we want repeated constatnly
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateAppState()
        }
    }
    
//    Helper messages that can be displayed to the user
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            print("For some reason, augmented reality tracking isn’t available.")
        case .normal:
            print("Tracking state normal")
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                print("You’re moving the device around too quickly. Slow down.")
            case .insufficientFeatures:
                print("I can’t get a sense of the room. Is something blocking the rear camera?")
            case .initializing:
                print("Initializing — please wait a moment...")
            case .relocalizing:
                print("Relocalizing — please wait a moment...")
            @unknown default:
                print("Unknown default")
            }
        }
    }
    
//    Updates the appState when planes are detected or not
    
    private func updateAppState() {
        guard appState == .pointToSurface || appState == .readyToFurnish else {return}
        
        if isAnyPlaneInView() {
            appState = .readyToFurnish
        } else {
            appState = .pointToSurface
        }
    }
    
    private func isAnyPlaneInView() -> Bool {
        let screenDivisions = 5 - 1
        let viewWidth = view.bounds.size.width
        let viewHeight = view.bounds.size.height
        
//       Break screen into 5 x 5 divisions and perform a hit test on each one
        
        for y in 0...screenDivisions {
            let yCoord = CGFloat(y) / CGFloat(screenDivisions) * viewHeight
            for x in 0...screenDivisions {
                let xCoord = CGFloat(x) / CGFloat(screenDivisions) * viewWidth
                let point = CGPoint(x: xCoord, y: yCoord)
                
                let hitTest = sceneView.hitTest(point, types: .estimatedHorizontalPlane)
                
                if !hitTest.isEmpty {
                    return true
                }
            }
            
        }
        return false
    }
    
//    MARK: - Plane Detection
    
//      Gets called every time the node for a new anchor get added

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        if planeAnchor.alignment == .horizontal {
            
            print("horizontal plane detected")
        } else if planeAnchor.alignment == .vertical {

            print("vertical plane detected")
        }
        
//        Draw plane over detected surface
        
        drawPlaneNode(on: node, for: planeAnchor)
        
    }
    
//    Gets called when an existing anchor is updated
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
//        Remove child nodes that might exist
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
//        Draw new plane over detected surface
        drawPlaneNode(on: node, for: planeAnchor)
    }
    
    private func drawPlaneNode(on node: SCNNode, for planeAnchor: ARPlaneAnchor) {
        
//        Create node same size as detected plane
        let planeNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
//        Position node in center of plane
        
        planeNode.position = SCNVector3(planeAnchor.center.x,
                                        planeAnchor.center.y,
                                        planeAnchor.center.z)
        
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        
        planeNode.eulerAngles = SCNVector3(-Double.pi / 2,0,0)
        
        if planeAnchor.alignment == .horizontal {
            print("It's horizontal")
            planeNode.name = "horizontal"
        } else {
//            If vertical plance, add node as child
            planeNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "1")
            planeNode.name = "vertical"
            node.addChildNode(planeNode)

        }
        
        appState = .readyToFurnish
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
//        Gets called if node corresponding to anchor is removed
        guard anchor is ARPlaneAnchor else {return}
//        Remove child nodes
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    // MARK: - AR session error management

      func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("AR session failure: \(error)")
      }

      func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("AR session was interrupted!")
      }

      func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("AR session interruption ended.")
        resetARSession()
      }

}
