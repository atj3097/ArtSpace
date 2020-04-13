//
//  ArtObject.swift
//  ArtSpaceDos
//
//  Created by Adam Jackson on 1/30/20.
//  Copyright © 2020 Adam Jackson. All rights reserved.
//


import UIKit
import FirebaseFirestore

struct ArtObject {
  //MARK: TODO: Add artTitle as a property 
    let artistName: String
    let artDescription: String
    let width: CGFloat
    let height: CGFloat
    let artImageURL: String
    let artID: String
    let sellerID: String
    let price: Double
  //MARK: TODO: remove default status
    var soldStatus: Bool
    let dateCreated: Date?
    let tags: [String]
    
//    MARK: - TODO: Filter favorites by userID once login is functional. See commented-out code below.
    func existsInFavorites(completion: @escaping (Result <Bool, Error>) -> ()) {
        FirestoreService.manager.getAllSavedArtObjects { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let favorites):
                if favorites.contains(where: {$0.artID == self.artID}) {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
    
//    func existsInFavorites(completion: @escaping (Result<Bool,Error>) -> ()) {
//
//            guard let user = FirebaseAuthService.manager.currentUser else {return}
//
//            FirestoreService.manager.getArts(forUserID: user.uid) { (result) in
//                switch result {
//                case .failure(let error):
//                    completion(.failure(error))
//                    print(error)
//                case .success(let events):
//                    if events.contains(where: {$0.id == self.id}) {
//                        completion(.success(true))
//                    } else {
//                        completion(.success(false))
//                    }
//                }
//            }
//        }
//    }
    
//    MARK: - Init
  
    init(artistName: String, artDescription: String, width: CGFloat, height: CGFloat, artImageURL: String, sellerID: String, price: Double, dateCreated: Date? = nil, tags: [String], soldStatus: Bool){
        self.artistName = artistName
        self.artDescription = artDescription
        self.width = width
        self.height = height
        self.artImageURL = artImageURL
        self.artID = UUID().uuidString
        self.sellerID = sellerID
        self.price = price
        self.dateCreated = dateCreated
        self.tags = tags
        self.soldStatus = soldStatus
    }
    
    init?(from dict: [String:Any], id: String) {
        guard let artistName = dict["artistName"] as? String,
        let artDescription = dict["artDescription"] as? String,
        let width = dict["width"] as? CGFloat,
        let height = dict["height"] as? CGFloat,
        let artImageURL = dict["artImageURL"] as? String,
        let artID = dict["artID"] as? String,
        let sellerID = dict["sellerID"] as? String,
        let price = dict["price"] as? Double,
        let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue(),
        let tags = dict["tags"] as? [String], let sold = dict["soldStatus"] as? Bool else {return nil}
        
        self.artistName = artistName
        self.artDescription = artDescription
        self.width = width
        self.height = height
        self.artImageURL = artImageURL
        self.sellerID = sellerID
        self.price = price
        self.dateCreated = dateCreated
        self.artID = artID
        self.tags = tags
        self.soldStatus = sold
    }
    
    var fieldsDict: [String:Any] {
        return ["artistName": self.artistName, "artDescription": self.artDescription, "width": self.width, "height": self.height, "artImageURL": self.artImageURL, "artID": self.artID, "sellerID": self.sellerID, "price": self.price, "tags": self.tags, "soldStatus": self.soldStatus ]
    }
    
}
