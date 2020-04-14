//
//  LoginViewController.swift
//  ArtSpaceDos
//
//  Created by Adam Jackson on 2/18/20.
//  Copyright © 2020 Adam Jackson. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    private enum SignInMethod {
        case logIn
        case register
    }
    private var signInMethod: SignInMethod = .logIn

    //MARK: UI Elements
    lazy var gifView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.gif(asset: "artSpace")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "ArtSpace", size: 0, alignment: .center)
        label.font = UIFont(name: "SnellRoundhand-Bold", size: 50)
        label.textColor = .white
        return label
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let items = ["Login", "Register"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        let font = UIFont.systemFont(ofSize: 20)
        sc.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        sc.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        sc.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        return sc
    }()
    
    lazy var emailTextField: UITextField = {
        let input = UITextField()
        UIUtilities.setupTextView(input, placeholder: "Enter Email", alignment: .center)
        input.backgroundColor = .white
        input.textColor = ArtSpaceConstants.artSpaceBlue
        input.alpha = 0.90
        input.layer.cornerRadius = 10.0
        input.clipsToBounds = true
        input.attributedPlaceholder = NSAttributedString(string: "Enter Email", attributes: [NSAttributedString.Key.foregroundColor: ArtSpaceConstants.artSpaceBlue.withAlphaComponent(0.75)])
        return input
    }()
    
    lazy var usernameTextField: UITextField = {
        let input = UITextField()
        UIUtilities.setupTextView(input, placeholder: "Enter Username", alignment: .center)
        input.backgroundColor = .white
        input.textColor = ArtSpaceConstants.artSpaceBlue
        input.alpha = 0.90
        input.layer.cornerRadius = 10.0
        input.clipsToBounds = true
        input.attributedPlaceholder = NSAttributedString(string: "Enter Username",
                                                         attributes: [NSAttributedString.Key.foregroundColor: ArtSpaceConstants.artSpaceBlue.withAlphaComponent(0.75)])
        return input
    }()
    
    lazy var passwordTextField: UITextField = {
        let input = UITextField()
        UIUtilities.setupTextView(input, placeholder: "Enter Password", alignment: .center)
        input.backgroundColor = .white
        input.isSecureTextEntry = true
        input.textColor = ArtSpaceConstants.artSpaceBlue
        input.alpha = 0.90
        input.layer.cornerRadius = 10.0
        input.clipsToBounds = true
        input.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                         attributes: [NSAttributedString.Key.foregroundColor: ArtSpaceConstants.artSpaceBlue.withAlphaComponent(0.75)])
        return input
    }() 
    
    lazy var loginButton: UIButton = {
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: 250, height: 40))
        UIUtilities.setUpButton(button, title: "Login", backgroundColor:  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) , target: self, action: #selector(loginOrRegisterUser))
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        dismissKeyboardWithTap()
    UIUtilities.addSubViews([gifView,titleLabel,emailTextField,passwordTextField,loginButton, segmentedControl,usernameTextField], parentController: self)
        usernameTextField.isHidden = true
        setUpConstraints()
    }
    
    //MARK: Objective C
    @objc func loginOrRegisterUser() {
      self.showActivityIndicator(shouldShow: true)
      
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(with: "Error", and: "Please fill out all fields.")
            return
        }
        
        guard email.isValidEmail else {
            showAlert(with: "Error", and: "Please enter a valid email")
            return
        }
        
        guard password.isValidPassword else {
            showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
            return
        }
        switch signInMethod {
        case .logIn:
        FirebaseAuthService.manager.loginUser(email: email.lowercased(), password: password) { (result) in
            self.handleLoginAccountResponse(with: result)
        }
        case .register:
            FirebaseAuthService.manager.createNewUser(email: email.lowercased(), password: password, completion: {(result) in
              self.showActivityIndicator(shouldShow: false)
                self.handleCreateAccountResponse(with: result)
            })
    }
    }
    
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginButton.setTitle("Log In", for: .normal)
            signInMethod = .logIn
            usernameTextField.isHidden = true
        } else {
            loginButton.setTitle("Register", for: .normal)
            signInMethod = .register
            usernameTextField.isHidden = false
        }
    }
    
    @objc func dismissKeyboard() {
         view.endEditing(true)
       }
    

    private func dismissKeyboardWithTap() {
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      view.addGestureRecognizer(tap)
    }
    
   
   
  func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

}
