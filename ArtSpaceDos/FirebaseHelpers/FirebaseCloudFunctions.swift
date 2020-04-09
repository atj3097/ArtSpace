//
//  FirebaseCloudFunctions.swift
//  ArtSpaceDos
//
//  Created by God on 4/9/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import Foundation
import FirebaseFunctions

enum cloudFunctionNames: String {
    case createCustomer
}


class CloudFunctions {
    static let manager = CloudFunctions()
    
    private let functions: Functions!

    private init() {
        functions = Functions.functions()
    }
    
    func createStripeCustomer(email: String, newUser: AppUser, completion: @escaping (Result<String, Error>) -> ()) {
        functions.httpsCallable(cloudFunctionNames.createCustomer.rawValue).call { (result, error) in
            
        }
        
    }

}


