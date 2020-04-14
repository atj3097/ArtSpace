

import UIKit
import SnapKit
import Kingfisher

class HomePageViewController: UIViewController {
  
  //MARK: - Properties
  var artObjectData = [ArtObject]() {
    didSet {
      self.artCollectionView.reloadData()
    }
  }
    
  var currentFilters = [String]()
  var isCurrentlyFiltered = false
  let cellSpacing: CGFloat = 5.0
  
  lazy var artCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout.init()
    let collectionView = UICollectionView(frame:.zero , collectionViewLayout: layout)
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: 250, height: 250)
    collectionView.register(ArtCell.self, forCellWithReuseIdentifier: ReuseIdentifier.artCell.rawValue)
    UIUtilities.setViewBackgroundColor(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()
  
  
  //MARK: -- Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    UIUtilities.setViewBackgroundColor(view)
    addSubviews()
    setupUIConstraints()
    getArtPosts()

  }
 
  //MARK: - Obj-C Functions
  @objc func transitionToFilterVC() {
    let filterView = FilterViewController()
    filterView.modalPresentationStyle = .overCurrentContext
    filterView.modalTransitionStyle = .crossDissolve
    filterView.filterDelegate = self
    if isCurrentlyFiltered {
      filterView.tagArray = currentFilters
    } else {
      filterView.tagArray = [String]()
    }
    self.navigationController?.present(filterView, animated: true, completion: nil)
  }
  
  
  //MARK: -- Private Functions
  private func getArtPosts() {
    self.showActivityIndicator(shouldShow: true)
    FirestoreService.manager.getAllArtObjects { [weak self](result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let artFromFirebase):
        DispatchQueue.main.async {
          self?.artObjectData = artFromFirebase
          self?.showActivityIndicator(shouldShow: false)
        }
      }
    }
  }
  
  private func setupNavigationBar() {
    let filterButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(transitionToFilterVC))
    UIUtilities.setUpNavigationBar(title: "ArtSpace", viewController: self, leftBarButton: filterButton)
  }
    
    @objc private func profileTransition() {
        let viewController = ProfileViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
        
  
  private func showAlert(with title: String, and message: String) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    present(alertVC, animated: true, completion: nil)
  }
    
  //MARK: - UISetup Functions
  private func addSubviews() {
    self.view.addSubview(artCollectionView)
  }
  
  private func setupUIConstraints() {
    artCollectionView.snp.makeConstraints { make in
      //MARK: TO DO revise constraints to super view
      make.top.equalTo(view).offset(100)
      make.left.equalTo(self.view.safeAreaLayoutGuide)
      make.bottom.equalTo(self.view)
      make.right.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}

extension HomePageViewController: FilterTheArtDelegate {
  func cancelFilters() {
    //Resets the filters by calling the original art objects from Firebase
    getArtPosts()
    isCurrentlyFiltered = false
  }
  
  func getTagsToFilter(get tags: [String]) {
    loadFilteredPosts(tags: tags)
    //Assigns the tags filtering the collection view to a variable that will be passed back to the Filtering View Controller
    currentFilters = tags
    //A bool that determines whether on not the view Controller is filtered, will be passed back to filter view controller so that the user doesnt repeat filters
    isCurrentlyFiltered = true
  }
  
  func loadFilteredPosts(tags: [String]) {
    //Checking to make sure that there are tags to be filtered
    guard tags.count > 0 else {
      showAlert(with: "Oops!", and: "Please select a filter!")
      //Resets All Art If There Is No Filter
      getArtPosts()
      return
    }
    //Filtering through the art object data based upon the tags selected
    artObjectData = artObjectData.filter({$0.tags.contains(tags[0].lowercased())
    })
  }
  
}

extension HomePageViewController: ArtCellFavoriteDelegate {
  //    MARK: - TODO: Update code to use Current User
  func faveArtObject(tag: Int) {
    let oneArtObject = artObjectData[tag]
    let _ = oneArtObject.existsInFavorites { (result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let bool):
        switch bool {
        case true:
    FirestoreService.manager.removeSavedArtObject(artID: oneArtObject.artID) { (result) in
            switch result {
            case .failure(let error):
              print(error)
            case .success(()):
              print("You deleted that art from favorites")
            }
          }
        case false:
          FirestoreService.manager.createFavoriteArtObject(artObject: oneArtObject) { (result) in
            switch result {
            case .failure(let error):
              print(error)
            case .success(()):
              print("You saved that to favorites")
            }
          }
        }
      }
    }
  }
}
