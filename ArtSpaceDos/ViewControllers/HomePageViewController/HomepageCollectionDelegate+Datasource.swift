//
//  HomepageCollectionDelegate+Datasource.swift
//  ArtSpaceDos
//
//  Created by God on 4/13/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit

//MARK: -- Extensions
extension HomePageViewController: UICollectionViewDataSource {
  //MARK: Research Diffable Data Source
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return artObjectData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = artCollectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.artCell.rawValue, for: indexPath) as? ArtCell else {return UICollectionViewCell()}

    let currentArt = artObjectData[indexPath.row]
    cell.titleOfArt.text = currentArt.sellerID
    cell.priceLabel.text = "$\(currentArt.price)0"
    let currentImage = artObjectData[indexPath.row]
    let url = URL(string: currentImage.artImageURL)
    cell.imageView.kf.setImage(with: url)
    cell.delegate = self
    cell.likeButton.tag = indexPath.row
  
    let _ = currentImage.existsInFavorites { (result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let bool):
        switch bool {
        case true:
          cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        case false:
          cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
      }
    }
    return cell
  }
}


extension HomePageViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let specificArtObject = artObjectData[indexPath.row]
    //MARK: TO DO - Pass data of current cell to Detail View
    let detailVC = ArtDetailViewController()
    detailVC.currentArtObject = specificArtObject
    navigationController?.pushViewController(detailVC, animated: true)
  }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let numCells: CGFloat = 2
    let numSpaces: CGFloat = numCells + 1
    
    let screenWidth = UIScreen.main.bounds.width
    let screenheight = UIScreen.main.bounds.height
    
    return CGSize(width: screenWidth, height: screenheight / 1.5)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return cellSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return cellSpacing
  }
}
