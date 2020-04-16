//
//  SaveCardViewController.swift
//  ArtSpaceDos
//
//  Created by Adam Jackson on 3/19/20.
//  Copyright © 2020 Adam Jackson. All rights reserved.
//

import UIKit
import Stripe
import SnapKit

class SaveCardViewController: STPAddCardViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationButtons()
    }
    private func setUpNavigationButtons() {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveCard))
        self.navigationItem.rightBarButtonItem = button
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backToProfile))
        self.navigationItem.leftBarButtonItem = cancel
    }
    
    @objc func saveCard() {
        let cardParams = STPCardParams()
        cardParams.name = "Test Name"
        cardParams.number = "4242424242424242"
        cardParams.expMonth = 04
        cardParams.expYear = 23
        cardParams.cvc = "882"
    
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            guard let token = token, error == nil else {
                print(error)
                return
            }
            FirestoreService.manager.saveToken(tokenId: token.tokenId)
            print(token.tokenId)
        }
        
        showAlert(with: "Thank You!", and: "You can now purchase art pieces from our app")
    }
    @objc private func backToProfile() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(with title: String, and message: String) {
      let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in
          self.dismiss(animated: true, completion: nil)
      }))
      present(alertVC, animated: true, completion: nil)
    }
    
    
}
