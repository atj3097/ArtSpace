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
        view.addSubview(detailView)
        detailView.currentArtObject = currentArtObject
        fillUIData()
    }
    private func fillUIData() {
        detailView.artName.text = currentArtObject.sellerID
        detailView.priceNameLabel.text = "Price: $\(currentArtObject.price)"
        let heighMeasurement = Measurement(value: Double(currentArtObject.height), unit: UnitLength.meters)
        let widthMeasurement = Measurement(value: Double(currentArtObject.width), unit: UnitLength.meters)
        let centimeterWidth = heighMeasurement.converted(to: .centimeters)
        let centimeterHeight = widthMeasurement.converted(to: .centimeters)
        detailView.dimensionsLabel.text = "H x \(centimeterHeight) W x \(centimeterWidth)"
        detailView.artistNameLabel.text = "Artist: @\(currentArtObject.artistName.lowercased())"
        detailView.artDescription.text = "\(currentArtObject.artDescription)"
        let url = URL(string: currentArtObject.artImageURL)
        detailView.artImageView.kf.setImage(with: url)
        detailView.buyNowButton.setTitle("$\(currentArtObject.price)0", for: .normal)
    }
    
    
 
  
}
