//
//  MainTabVC.swift
//  ArtSpaceDos
//
//  Created by Adam Jackson on 2/6/20.
//  Copyright © 2020 Adam Jackson. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {
  
  //MARK: Properties
  lazy var homePage = UINavigationController(rootViewController: MainViewController())
  lazy var profile = UINavigationController(rootViewController: ProfileViewController())
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tabBar.unselectedItemTintColor = .secondarySystemFill
    self.tabBar.tintColor = .white
    self.tabBar.backgroundColor = ArtSpaceConstants.artSpaceBlue
    tabBar.barTintColor = ArtSpaceConstants.artSpaceBlue
    setTabItems()
  }
  
  private func setTabItems() {
    homePage.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: 0)
    homePage.tabBarItem.badgeColor = .red
    profile.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 3)
    
    self.viewControllers  = [homePage, profile]
  }
}
