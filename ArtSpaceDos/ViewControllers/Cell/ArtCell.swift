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
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        return label
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
    
//    MARK: - ObjC Functions
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
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
    }
    
    func addConstraints() {
        
        imageView.snp.makeConstraints{ make in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(5)
            make.right.equalTo(contentView).offset(-5)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-5)
        }
        
        
    }
    
}
