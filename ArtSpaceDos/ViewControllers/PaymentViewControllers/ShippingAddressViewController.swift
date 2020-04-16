//
//  ShippingAddressViewController.swift
//  ArtSpaceDos
//
//  Created by God on 3/19/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import Stripe

class ShippingAddressViewController: STPShippingAddressViewController {
    var price: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationButtons()
        // Do any additional setup after loading the view.
    }
    
    private func setUpNavigationButtons() {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(makePayment))
        self.navigationItem.rightBarButtonItem = button
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPayment))
        self.navigationItem.leftBarButtonItem = cancel
    }
    @objc private func cancelPayment() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func makePayment() {
        FirestoreService.manager.createCharge(amount: price)
        showAlert(with: "Thank You For Your Purchase!", and: "Our Shipping and Handling Takes About 7 Days 😊")

    }
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertVC, animated: true, completion: nil)
    }
}
