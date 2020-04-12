//
//  UserProfileCell.swift
//  ArtSpaceDos
//
//  Created by Adam Jackson on 4/11/20.
//  Copyright © 2020 Adam Jackson. All rights reserved.
//

import UIKit

import UIKit

class UserProfileCell: UITableViewCell {
    var currentItemId: Int?
    var parentViewController: UIViewController?
    lazy var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "", size: 20, alignment: .center)
        label.textColor = ArtSpaceConstants.artSpaceBlue
        label.font = UIFont(name: "Avenir", size: 20)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    lazy var numberOfTimes: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "", size: 30, alignment: .center)
        label.textColor = .white
        label.font = UIFont(name: "Avenir", size: 30)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
               return label
    }()
    
    lazy var greenLayer: UIView = {
        let view = UIView()
        view.backgroundColor = ArtSpaceConstants.artSpaceBlue
        view.alpha = 0.30
        return view
    }()
    
    lazy var trashIcon: UIButton = {
        let button = UIButton()
        UIUtilities.setUpButton(button, title: "", backgroundColor: .clear, target: self, action: #selector(removeFromCart))
//        let image = UIImage(systemName: "trash")
//        button.setImage(image, for: .normal)
        button.tintColor = ArtSpaceConstants.artSpaceBlue
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          addSubviews()
          constraints()
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      // MARK: - Lifecycle Functions
      override func awakeFromNib() {
          super.awakeFromNib()
          // Initialization code
      }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func removeFromCart() {
        showAlert(with: "Swipe Right To Delete this Item", and: "", parentController: parentViewController!)
    }
    private func addSubviews() {
//        addSubview(greenLayer)
        addSubview(recipeImageView)
        addSubview(title)
        addSubview(numberOfTimes)
        addSubview(trashIcon)
    }
    
    private func showAlert(with title: String, and message: String, parentController: UIViewController) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        parentController.present(alertVC, animated: true, completion: nil)
    }
    
    private func constraints() {
//        greenLayer.translatesAutoresizingMaskIntoConstraints = false
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeImageView.addSubview(greenLayer)
        title.translatesAutoresizingMaskIntoConstraints = false
        numberOfTimes.translatesAutoresizingMaskIntoConstraints = false
        trashIcon.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            greenLayer.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor),
//            greenLayer.topAnchor.constraint(equalTo: recipeImageView.topAnchor),
//            greenLayer.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor),
//            greenLayer.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor)
//        ])
        
        
        //Recipe Image
        NSLayoutConstraint.activate([
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            title.heightAnchor.constraint(equalToConstant: 30),
            title.topAnchor.constraint(equalTo: topAnchor,constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            numberOfTimes.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberOfTimes.leadingAnchor.constraint(equalTo: leadingAnchor),
            numberOfTimes.trailingAnchor.constraint(equalTo: trailingAnchor),
            numberOfTimes.heightAnchor.constraint(equalToConstant: self.frame.height / 0.5),
            numberOfTimes.topAnchor.constraint(equalTo: title.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
           trashIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
           
           trashIcon.topAnchor.constraint(equalTo: topAnchor,constant: 10)
            
        ])
        
        
        
    }

}

