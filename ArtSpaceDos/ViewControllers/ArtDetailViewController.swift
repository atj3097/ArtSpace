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
    
    //MARK: - Properties
    var currentArtObject: ArtObject!
    
    // MARK: - UI Objects
    lazy var artName: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "", size: 25, alignment: .left)
        label.textColor = ArtSpaceConstants.artSpaceBlue
        label.numberOfLines = 0
        return label
    }()
    lazy var artImageView: UIImageView = {
        let imageView = UIImageView()
        UIUtilities.setUpImageView(imageView, image: UIImage(imageLiteralResourceName: "noimage"), contentMode: .scaleAspectFill)
        imageView.layer.shadowColor = UIColor(red: 35/255, green: 46/255, blue: 33/255, alpha: 1).cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        imageView.layer.shadowOpacity = 0.9
        imageView.layer.shadowRadius = 4
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(arButtonTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    lazy var artDescription: UITextView = {
         let summary = UITextView()
        summary.textAlignment = .left
        summary.backgroundColor = .clear
        summary.isUserInteractionEnabled = false
        summary.textColor = ArtSpaceConstants.artSpaceBlue
         summary.text = ""
        summary.font = UIFont(name: "Avenir", size: 15)
//         summary.font = summary.font?.withSize(20)
         return summary
     }()
    
    lazy var dimensionsLabel: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "Size", size:  17, alignment: .center)
        label.textColor = ArtSpaceConstants.artSpaceBlue
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "", size: 20, alignment: .center)
        label.textColor = ArtSpaceConstants.artSpaceBlue
//        label.font = UIFont(name: "", size: <#T##CGFloat#>)
        return label
    }()
    
    lazy var priceNameLabel: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "", size: 20, alignment: .center)
        return label
    }()

        lazy var arLogo: UIImageView = {
            let Imagelogo = UIImageView()
            UIUtilities.setUpImageView(Imagelogo, image: #imageLiteral(resourceName: "oculus"), contentMode: .scaleAspectFit)
            Imagelogo.translatesAutoresizingMaskIntoConstraints = false
           Imagelogo.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(arButtonTapped(_:)))
            Imagelogo.addGestureRecognizer(tapGesture)
            return Imagelogo
        }()
    
    lazy var buyNowButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 40))
        UIUtilities.setUpButton(button, title: "", backgroundColor: ArtSpaceConstants.artSpaceBlue, target: self, action: #selector(buyNowButtonPressed))
        button.titleLabel?.font = UIFont(name: "Avenir", size: 40)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
//        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
//        button.addTarget(self, action: #selector(arButtonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.shadowColor = UIColor(red: 35/255, green: 46/255, blue: 33/255, alpha: 1).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 1
        view.addSubview(button)
        return button
    }()
    
    lazy var tapForAugmentedReality: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "AR", size: 14, alignment: .center)
        label.textColor = ArtSpaceConstants.artSpaceBlue
        return label
    }()
    
 
    //MARK: - Obj-C Functions
    @objc func buyNowButtonPressed() {
        FirestoreService.manager.createCharge(amount: Int(currentArtObject.price))
    let config = STPPaymentConfiguration()
    config.requiredShippingAddressFields = [.postalAddress]
        let theme = STPTheme.default()
    let viewController = STPShippingAddressViewController(configuration: config,
                                                          theme: theme,
                                                          currency: "usd",
                                                          shippingAddress: nil,
                                                          selectedShippingMethod: nil,
                                                          prefilledInformation: nil)
//    viewController.delegate = self
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.navigationBar.stp_theme = theme
    present(navigationController, animated: true, completion: nil)
        currentArtObject.soldStatus = true
    }
    // MARK: arButtonNavigation
    @objc func arButtonTapped(_ tapGesture: UITapGestureRecognizer) {
        let newViewController = ARViewController()
        newViewController.artObject = self.currentArtObject
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    
    
    //MARK:- Private func
    private func getArtPosts() {
        priceNameLabel.text = "Price: $\(currentArtObject.price)"
        let heighMeasurement = Measurement(value: Double(currentArtObject.height), unit: UnitLength.meters)
        let widthMeasurement = Measurement(value: Double(currentArtObject.width), unit: UnitLength.meters)
        let centimeterWidth = heighMeasurement.converted(to: .centimeters)
        let centimeterHeight = widthMeasurement.converted(to: .centimeters)
        dimensionsLabel.text = "H x \(centimeterHeight) W x \(centimeterWidth)"
        artistNameLabel.text = "Artist: @\(currentArtObject.artistName.lowercased())"
        artDescription.text = "\(currentArtObject.artDescription)"
         let url = URL(string: currentArtObject.artImageURL)
        artImageView.kf.setImage(with: url)
        
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        UIUtilities.setViewBackgroundColor(view)
        addSubviews()
        setupUIConstraints()
        getArtPosts()
        buyNowButton.setTitle("$\(currentArtObject.price)0", for: .normal)
        
    }
    
    //MARK: - Private functions
    //MARK: TO DO - Pass data into the UI elements
    private func addSubviews() {
        view.addSubview(artImageView)
        view.addSubview(artistNameLabel)
        view.addSubview(artName)
        view.addSubview(buyNowButton)
        view.addSubview(arLogo)
        view.addSubview(dimensionsLabel)
        view.addSubview(artDescription)
        view.addSubview(tapForAugmentedReality)
    }
    
    private func setupUIConstraints() {
        constrainDimensionLabel()
        constrainArtLabel()
        constrainBuyButton()
        constrainARButton()
        constrainArtView()
        descriptionConstraints()
    }
    
    // MARK: - Constraints
    private func constrainDimensionLabel() {
        dimensionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimensionsLabel.topAnchor.constraint(equalTo: artName.bottomAnchor),
            dimensionsLabel.centerXAnchor.constraint(equalTo: artName.centerXAnchor)
        
        ])
    } 
    
    private func constrainArtView() {
        artName.text = currentArtObject.sellerID
        artName.snp.makeConstraints{ make in
            make.top.equalTo(view).offset(60)
            make.centerX.equalTo(view)
        }
        
        artImageView.snp.makeConstraints{ make in
            make.bottom.equalTo(artName).offset(300)
            make.centerX.equalTo(view)
            make.height.equalTo(200)
            make.width.equalTo(250)
        }
    } 
    
    private func constrainArtLabel() {
        artistNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(artImageView).offset(100)
            make.left.equalTo(view).offset(20)
            }
    }

  
  private func  constrainBuyButton() {
    buyNowButton.snp.makeConstraints { make in
      make.centerX.equalTo(view)
        make.bottom.equalTo(view).offset(-75)
        make.width.equalTo(300)
        make.height.equalTo(60)
    }
    
  }
  private func  constrainARButton() {
    arLogo.snp.makeConstraints { make in
        make.top.equalTo(artName)
        make.right.equalTo(view).offset(-15)
      make.size.equalTo(CGSize(width: 30, height: 30))
    }
    tapForAugmentedReality.snp.makeConstraints{ make in
        make.bottom.equalTo(arLogo).offset(20)
        make.centerX.equalTo(arLogo)

    }
    
  }
  
  private func descriptionConstraints() {
    artDescription.snp.makeConstraints { (make) in
      make.left.equalTo(artistNameLabel)
      make.bottom.equalTo(artistNameLabel).offset(50)
        make.width.equalTo(220)
        make.height.equalTo(50)
        
    }
    
  }
  
}
