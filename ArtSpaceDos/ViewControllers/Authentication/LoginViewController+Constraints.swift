//
//  LoginViewController+Constraints.swift
//  ArtSpaceDos
//
//  Created by God on 4/13/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import SnapKit
extension LoginViewController {
    func setUpConstraints() {
        gifView.snp.makeConstraints{ make in
            make.height.equalTo(view)
            make.width.equalTo(view).offset(100)
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(view).offset(50)
            make.centerX.equalTo(view)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view).offset(125)
            make.centerX.equalTo(view)
            make.height.equalTo(30)
            make.width.equalTo(175)
        }
        
        emailTextField.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel).offset(150)
            make.centerX.equalTo(view)
            make.width.equalTo(titleLabel).offset(100)
            make.height.equalTo(40)
        }
        
        usernameTextField.snp.makeConstraints{ make in
            make.top.equalTo(emailTextField).offset(50)
            make.width.equalTo(emailTextField)
            make.centerX.equalTo(view)
            make.height.equalTo(40)
            
        }
        
        passwordTextField.snp.makeConstraints{ make in
            make.top.equalTo(emailTextField).offset(100)
            make.centerX.equalTo(view)
            make.width.equalTo(titleLabel).offset(100)
            make.height.equalTo(40)
        }

        loginButton.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField).offset(100)
            make.centerX.equalTo(view)
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
    }
}
