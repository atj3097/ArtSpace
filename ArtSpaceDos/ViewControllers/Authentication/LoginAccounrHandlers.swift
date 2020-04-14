//
//  LoginAccounrHandlers.swift
//  ArtSpaceDos
//
//  Created by God on 4/13/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import Firebase
extension LoginViewController {
   func handleLoginAccountResponse(with result: Result<(), Error>) {
        DispatchQueue.main.async {
            switch result {
            case .failure(let error):
                self.showAlert(with: "Error", and: "Could not log in. Error: \(error)")
            case .success:
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let sceneDelegate = windowScene.delegate as? SceneDelegate
                    else {
                        return
                }
                UIView.transition(with: self.view, duration: 0.1, options: .transitionFlipFromBottom, animations: {
                  let mainViewController = MainTabBarController()
                    mainViewController.modalPresentationStyle = .overCurrentContext
                    sceneDelegate.window?.rootViewController = mainViewController
                }, completion: nil)
            }
        }
    }
 func handleCreateAccountResponse(with result: Result<User, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let user):
                FirestoreService.manager.createAppUser(user: AppUser(from: user, stripeId: "" )) { [weak self] newResult in
                    self?.addUserNameToUser(with: newResult)
             
                }
            case .failure(let error):
                self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
            }
        }
    }
    
    private func addUserNameToUser (with result: Result<Void, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success( _):
                FirestoreService.manager.updateCurrentUser(userName: self.usernameTextField.text ?? "", completion: { (result) in
                    self.handleCreatedUserInFirestore(result: result)
                })
            case .failure(let error):
                self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
            }
        }
    }
    
    private func handleCreatedUserInFirestore(result: Result<Void, Error>) {
        switch result {
        case .success:
            let tabBarController = MainTabBarController()
            tabBarController.modalPresentationStyle = .overCurrentContext
            self.present(tabBarController, animated: true, completion: nil)
        case .failure(let error):
            self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
        }
    }
}
