//
//  ProfileViewController.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 2/6/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import FirebaseAuth
import Photos
import Firebase
import Kingfisher
import Stripe
class ProfileViewController: UIViewController {
    
    let profileOptions: [String: (UIImage, String)] = ["Saved Art": (UIImage(systemName: "bookmark")!, "See Your Favorite Art"), "Billing Info": (UIImage(systemName: "creditcard.fill")!, "Save A New Card Or Change Address"), "Purchase History": (UIImage(systemName: "book.fill")!, "See What You Bought!"), "Edit Profile": (UIImage(systemName: "person")!, "Customize Your Profile")]
    var displayNameHolder = "Display Name"
    var defaultImage = UIImage(systemName: "1")
    var settingFromLogin = false
    var photoLibraryAccess = true

  
    var imageURL: URL? = nil
    var savedImage = UIImage() {
        didSet {
            profileImage.image = savedImage
        }
    }
    
    lazy var tableView: UITableView = {
       let table = UITableView(frame: .zero, style: .plain)
       table.register(UserProfileCell.self, forCellReuseIdentifier: "profileCell")
        table.backgroundColor = .white
        return table
    }()

    
    //MARK: UI OBJC
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "atj2097", size: 30, alignment: .left)
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    lazy var buyerOrSeller: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "Buyer", size: 15, alignment: .left)
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var numberOfPosts: UILabel = {
        let label = UILabel()
               UIUtilities.setUILabel(label, labelTitle: "      0 \n Posts", size: 25, alignment: .left)
               label.textColor = .white
               label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        
               return label
    }()
    
    lazy var artPurchased: UILabel = {
        let label = UILabel()
               UIUtilities.setUILabel(label, labelTitle: "      0 \n Purchases", size: 25, alignment: .left)
               label.textColor = .white
               label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        
               return label
    }()
    
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "1")
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        image.layer.borderWidth = 5.0
        var frame = image.frame
        frame.size.width = 100
        frame.size.height = 100
        image.frame = frame
        image.clipsToBounds = true
        image.backgroundColor = .white
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        image.layer.cornerRadius = image.frame.size.width/2
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(gesture)
        return image
    }()
    
    
    
    
    lazy var editDisplayNameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(editDisplayNamePressed), for: .touchUpInside)
        return button
    }()
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter User Name"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .white
        //  textField.borderStyle = .bezel
        textField.layer.cornerRadius = 5
        textField.autocorrectionType = .no
        return textField
    }()
    
    lazy var uploadImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "icloud.and.arrow.up"), for: .normal)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        button.backgroundColor = .clear
        button.contentMode = .scaleAspectFill
        
        return button
    }()
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.hidesWhenStopped = true
        activityView.color = .white
        activityView.stopAnimating()
        return activityView
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("Save Changes", for: .normal)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    
    lazy var savePaymentInformation: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        UIUtilities.setUpButton(button, title: "Save Card", backgroundColor: .white, target: self, action: #selector(stripeSaveCard))
        button.layer.borderWidth = 2.0
               button.layer.cornerRadius = 15
               button.layer.borderColor = UIColor.systemBlue.cgColor
        return button
    }()
    
    lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "profileBackground")
        return imageView
    }()
    
    
    //MARK: addSubviews
    func addSubviews() {
        view.addSubview(profileImage)
        view.addSubview(buyerOrSeller)
        view.addSubview(numberOfPosts)
        // view.addSubview(uploadButton)
//        view.addSubview(uploadImageButton)
//        view.addSubview(saveButton)
         view.addSubview(userNameLabel)
//        view.addSubview(textField)
        view.addSubview(editDisplayNameButton)
//        view.addSubview(savePaymentInformation)
    }
    //MARK:ViewDidLoad cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.isHidden = true
        backgroundImage.snp.makeConstraints({ make in
            make.top.equalTo(self.view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        })
        addSubviews()
        constrainProfilePicture()
//        saveChangesConstraints()
      constrainDisplayname()
        editUserNameConstraints()
//        uploadImageConstraints()
//        saveCardConstraints()
        if let displayName = FirebaseAuthService.manager.currentUser?.displayName {
            loadImage()
            userNameLabel.text = displayName
            let user = FirebaseAuthService.manager.currentUser
            imageURL = user?.photoURL
        }
        
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(signOutFunc))
//        self.navigationController?.navigationBar.isHidden = false
//        UIUtilities.setViewBackgroundColor(view)
        
    }

    //MARK: Private Functions
    private func setSceneDelegateInitialVC(with result: Result<User, Error>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case.success(let user):
                print(user)
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                    else { return }
                
                if FirebaseAuthService.manager.currentUser != nil {
                    UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                        window.rootViewController = MainTabBarController()
                    }, completion: nil)
                    
                } else {
                    print("No current user")
                }
                
                
            case .failure(let error):
                self?.showAlert(with: "Error Creating User", and: error.localizedDescription)
            }
            
        }
    }
    
    private func formValidation() {
        let validUserName = userNameLabel.text != displayNameHolder
        let imagePresent = profileImage.image != defaultImage
        saveButton.isEnabled = validUserName && imagePresent
    }
    //MARK: Objc functions
    
    @objc func signOutFunc(){
      self.showActivityIndicator(shouldShow: true)
        FirebaseAuthService.manager.logoutUser()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
            else { return}
        
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromTop, animations: {
            
            window.rootViewController = LoginViewController()
        }, completion: {_ in
          self.showActivityIndicator(shouldShow: false)
        })
    }
    
    
    @objc func saveButtonPressed() {
        guard let userName = userNameLabel.text, let image = profileImage.image else {
            print("Defaults are not working")
            return
        }
        
        let validInput = (userName != displayNameHolder) && (image != defaultImage)
        
        if validInput {
            
            guard let imageUrl = imageURL else {
                print("Not able to compute imageUrl")
                return
            }
            
            FirebaseAuthService.manager.updateUserFields(userName: userName, photoURL: imageUrl) { (result) in
                switch result {
                case .success():
                    FirestoreService.manager.updateCurrentUser(userName: userName, photoURL: imageUrl) {  (result) in
                        switch result {
                        case .success(): break
                            
                        //  self?.transitionToMainFeed()
                        case .failure(let error):
                            print("Failure to update current user: \(error)")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            showErrorAlert(title: "Missing Requirements", message: "Profile needs a username and image")
        }
        
        
    }
    private func showErrorAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc private func stripeSaveCard() {
        let saveCardVC = SaveCardViewController()
        saveCardVC.modalPresentationStyle = .overCurrentContext
        present(saveCardVC, animated: true, completion: nil)
        
    }
    @objc private func profileImageTapped(){
        print("Pressed")
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .denied, .restricted:
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                switch status {
                case .authorized:
                    self?.presentPhotoPickerController()
                case .denied:
                    print("Denied photo library permissions")
                default:
                    print("No usable status")
                }
            })
        default:
            presentPhotoPickerController()
        }
    }
    
    private func loadImage() {
        guard let imageUrl = FirebaseAuthService.manager.currentUser?.photoURL else {
            print("photo url not found")
            return
        }
        //King Fisher
        let url = URL(string:imageUrl.absoluteString)
        profileImage.kf.setImage(with: url)
        
        
    }
    
    private func presentPhotoPickerController() {
        DispatchQueue.main.async{
            let imagePickerViewController = UIImagePickerController()
            imagePickerViewController.delegate = self
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.allowsEditing = true
            imagePickerViewController.mediaTypes = ["public.image", "public.movie"]
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func updateButtonPressed(){
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        guard let userName = user.displayName else {return}
        self.activityIndicator.startAnimating()
        FirestoreService.manager.updateCurrentUser(userName: userName) { (result) in
            switch (result) {
            case .success():
                self.activityIndicator.stopAnimating()
                self.showAlertWithSucessMessage()
            case .failure(let error):
                print(error)
            }
        }
        
        self.showAlert(with: "Error", and: "It seem your image was not save. Please check your image format and try again")
        
    }
    @objc func editDisplayNamePressed() {
        let alert = UIAlertController(title: "UserName", message: nil, preferredStyle: .alert)
        
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter UserName"
        }
        
        guard let userNameField = alert.textFields else {return}
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ (alert) -> Void in
            
            self.userNameLabel.text = userNameField[0].text ?? self.displayNameHolder
            self.formValidation()
            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
    private func showAlertWithSucessMessage(){
        let alert = UIAlertController(title: "Success", message: "You have updated your profile", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (dismiss) in
            self.handleNavigationAwayFromVCAfterUpdating()
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    private func handleNavigationAwayFromVCAfterUpdating() {
        if settingFromLogin {
            self.dismiss(animated: true, completion: nil)
        }
    }
    //MARK: Constraints
    
    private func constrainProfilePicture() {
        
        profileImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(75)
            make.left.equalTo(view).offset(25)
            make.height.equalTo(profileImage.frame.height)
            make.width.equalTo(profileImage.frame.width)
        }
    }
    private func constrainDisplayname() {
        userNameLabel.snp.makeConstraints { (make) in
            make.right.equalTo(profileImage).offset(130)
            make.top.equalTo(profileImage)
        }
        
        buyerOrSeller.snp.makeConstraints{ (make) in
            make.left.equalTo(userNameLabel)
            make.top.equalTo(userNameLabel).offset(40)
        }
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: numberOfPosts.bottomAnchor,constant: 50),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        
        ])
    }
    
    private func uploadImageConstraints() {
        uploadImageButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.profileImage).offset(125)
            make.trailing.equalTo(self.editDisplayNameButton).offset(15)
            
        }
    }
    
    private func saveChangesConstraints() {
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(editDisplayNameButton).offset(50)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(120)
        }
    }
    
    
    private func editUserNameConstraints() {
        numberOfPosts.snp.makeConstraints { (make) in
            make.bottom.equalTo(profileImage).offset(75)
            make.left.equalTo(profileImage).offset(10)
        }
//        view.addSubview(artPurchased)
//        artPurchased.snp.makeConstraints({ (make) in
//            make.top.equalTo(numberOfPosts)
//            make.centerX.equalTo(view)
//        })
    }
 
    
    private func saveCardConstraints() {
        savePaymentInformation.snp.makeConstraints{ make in
            make.bottom.equalTo(saveButton).offset(50)
            make.centerX.equalTo(saveButton)
            make.width.equalTo(saveButton)
            make.height.equalTo(saveButton)
        }
    }
    
}

//MARK: Extension
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
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileOptions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? UserProfileCell else {return UITableViewCell()}
        cell.backgroundColor = .clear
        switch indexPath.row {
        case 0:
            cell.title.text = "Saved Art"
            cell.numberOfTimes.text = profileOptions["Save Art"]?.1
            cell.trashIcon.setImage(UIImage(systemName: "bookmark"), for: .normal)
        case 1:
            cell.title.text = "Billing Information"
            cell.trashIcon.setImage(UIImage(systemName: "creditcard.fill"), for: .normal)
        case 2:
            cell.title.text = "Purchase History"
            cell.trashIcon.setImage(UIImage(systemName: "book"), for: .normal)
        case 3:
            cell.title.text = "Edit Profile"
            cell.trashIcon.setImage(UIImage(systemName: "person.fill"), for: .normal)
        case 4:
            cell.title.text = "Post Your Own Art To Sell"
            cell.trashIcon.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        default:
            print("")
        }
 
        return cell
    }
    
    
}
