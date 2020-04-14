//
//  ArtDetailViewController.swift
//  ArtSpaceDos
//
//  Created by Adam Jackson on 1/30/20.
//  Copyright © 2020 Adam Jackson. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Stripe

class ArtDetailViewController: UIViewController {
    
    var currentArtObject: ArtObject!
    let detailView = ArtDetailView()
   
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        detailView.parentViewController = self
        detailView.currentArtObject = currentArtObject
        view.addSubview(detailView)
    }
    
    
 
  
}
