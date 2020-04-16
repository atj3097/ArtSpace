//
//  ProfileViewImagePickerDelegate.swift
//  ArtSpaceDos
//
//  Created by Adam Jackson on 4/13/20.
//  Copyright © 2020 Adam Jackson. All rights reserved.
//

import UIKit

extension ProfileViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            return
        }
        
        self.savedImage = selectedImage
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.7) else {
            return
        }
        
        FirebaseStorageService.manager.storeImage(pictureType: .profilePicture, image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url):
                print("working")
                print(result)
                self?.imageURL = url
                
            case .failure(let error):
                print("Notworking")
                print(error)
            }
        })
        self.activityIndicator.stopAnimating()
        picker.dismiss(animated: true, completion: nil)
    }
}
