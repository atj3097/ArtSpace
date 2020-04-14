//
//  ArtCell.swift
//  ArtSpaceDos
//
//  Created by Adam Jackson on 1/30/20.
//  Copyright © 2020 Adam Jackson. All rights reserved.
//

import UIKit
import SnapKit

class ArtCell: UICollectionViewCell {
    
    weak var delegate: ArtCellFavoriteDelegate?
    var currentArtObject: ArtObject!
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    lazy var titleOfArt: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "", size: 30, alignment: .left)
        label.textColor = ArtSpaceConstants.artSpaceBlue
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir", size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    lazy var priceLabel: UILabel = {
        var label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "", size: 30, alignment: .right)
        label.textColor = ArtSpaceConstants.artSpaceBlue
        label.font = UIFont(name: "Avenir", size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    lazy var informationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.9
        return view
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(scale: .large)
        button.backgroundColor = .black
        button.tintColor = .white
        button.setImage(UIImage(systemName: "heart", withConfiguration: imageConfig), for: .normal)
        button.layer.cornerRadius = CGFloat(integerLiteral: 50)
        button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        addConstraints()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupContentView() {
        contentView.backgroundColor = .systemGray2
        contentView.layer.shadowColor = UIColor(red: 35/255, green: 46/255, blue: 33/255, alpha: 1).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        contentView.layer.shadowOpacity = 0.9
        contentView.layer.shadowRadius = 4
    }
    @objc private func likeButtonPressed(sender: UIButton!) {
        delegate?.faveArtObject(tag: sender.tag)
        if likeButton.image(for: .normal) == UIImage(systemName: "heart") {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    
    func addSubViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(informationView)
        contentView.addSubview(titleOfArt)
        contentView.addSubview(priceLabel)
    }
    
    func addConstraints() {
        
        imageView.snp.makeConstraints{ make in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-5)
        }
        
        informationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            informationView.leftAnchor.constraint(equalTo: leftAnchor),
            informationView.rightAnchor.constraint(equalTo: rightAnchor),
            informationView.bottomAnchor.constraint(equalTo: bottomAnchor),
            informationView.heightAnchor.constraint(equalToConstant: contentView.frame.height / 7)
        ])
        
        titleOfArt.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleOfArt.leftAnchor.constraint(equalTo: leftAnchor),
            titleOfArt.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.rightAnchor.constraint(equalTo: rightAnchor,constant: -10),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        
    }
    
}
