//
//  ArtDetailViewFunctionalities.swift
//  ArtSpaceDos
//
//  Created by God on 4/13/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import Stripe

extension ArtDetailView {
    
    @objc func buyNowButtonPressed() {
        showAlert(with: "Fill Out Your Shipping Address", and: "Make Sure That You Have Save Your Card With Us")
    }
    
    
    // MARK: arButtonNavigation
    @objc func arButtonTapped(_ tapGesture: UITapGestureRecognizer) {
        let newViewController = ARViewController()
        newViewController.artObject = self.currentArtObject
        parentViewController.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style:.default, handler: {(alert: UIAlertAction!)  in
            self.showShippingController()
        }))
        parentViewController.present(alertVC, animated: true, completion: nil)
    }
    
    
    // Show Shipping Controller
    private func showShippingController() {
        let config = STPPaymentConfiguration()
        
        config.requiredShippingAddressFields = [.postalAddress]
        
        //Stripe Theme Design
        let theme = STPTheme.default()
        theme.accentColor = ArtSpaceConstants.artSpaceBlue
        theme.primaryBackgroundColor = .white
        theme.primaryForegroundColor = ArtSpaceConstants.artSpaceBlue
        theme.secondaryBackgroundColor = .white
        
        let viewController = ShippingAddressViewController(configuration: config, theme: theme, currency: "usd",shippingAddress: nil,selectedShippingMethod: nil, prefilledInformation: nil)
        viewController.price = Int(self.currentArtObject.price)
        
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.stp_theme = theme
    self.parentViewController.present(navigationController, animated: true, completion: nil)
    }
    
}
