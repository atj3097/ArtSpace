//
//  FirebaseCloudFunctions.swift
//  ArtSpaceDos
//
//  Created by Adam Jackson on 4/9/20.
//  Copyright © 2020 Adam Jackson. All rights reserved.
//

import Foundation
import FirebaseFunctions

enum cloudFunctionNames: String {
    case createStripeCustomer
}


class CloudFunctions {
    static let manager = CloudFunctions()
    
    private let functions: Functions!
    
    private init() {
        functions = Functions.functions()
    }
    
    func createStripeCustomer() -> String {
        var stripeId = String()
        functions.httpsCallable(cloudFunctionNames.createStripeCustomer.rawValue).call { (result, error) in
            switch result {
            case .some(let customerId):
                //?? Is this ok?
                stripeId = NSString(data: customerId.data as! Data, encoding: String.Encoding.utf8.rawValue)! as String
                print(stripeId)
            case .none:
                print("No Id Given")
            default:
                print("Revist Cloud Function Class")
            }
            
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print(code.debugDescription)
                    print(message)
                    print(details)
                }
            }
            
        }
        return stripeId
        
    }
    
}

