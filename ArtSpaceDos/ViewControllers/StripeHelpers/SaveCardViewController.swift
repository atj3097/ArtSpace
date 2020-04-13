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
    

    
    @objc private func testPayment() {
        FirestoreService.manager.createCharge(amount: 20)
        
    }
    
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
        cardParams.name = "Alissa Semple"
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
    }
    @objc private func backToProfile() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
