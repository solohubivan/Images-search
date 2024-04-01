//
//  MainViewController.swift
//  Images search
//
//  Created by Ivan Solohub on 20.02.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak private var mainTitleLabel: UILabel!
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var searchButton: UIButton!
    @IBOutlet weak private var bottomInfoLabel: UILabel!
    @IBOutlet weak private var openLocalImagesButton: UIButton!
    @IBOutlet weak private var openEditedImagesButton: UIButton!
    
    var networkMonitor: NetworkMonitor?
    var pixabayDataManager: PixabayDataManager?
    
    private var selectedImageCategory: String = AppConstants.MainViewController.defaultCategory
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pixabayDataManager = PixabayDataManager()
        checkInternetConnection()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customizeOpenLocalImgButton()
        customizeOpenEditedImgButton()
    }

    // MARK: - Orientation Lock

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: - Private methods

    private func updateTFCategoryButton() {
        let buttonTitle = selectedImageCategory
        let attributedString = createTFRightButtonName(name: buttonTitle)
        if let menuButton = searchTextField.rightView as? UIButton {
            menuButton.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    private func checkInternetConnection() {
        networkMonitor?.networkStatusChanged = { [weak self] isConnected in
            if !isConnected {
                DispatchQueue.main.async {
                    self?.showNoInternetAlert()
                }
            }
        }
        if let isConnected = networkMonitor?.isConnected, !isConnected {
            showNoInternetAlert()
        }
    }

    private func showNoInternetAlert() {
        let cancelAction = AlertFactory.createAlertAction(
            title: AppConstants.Alerts.alertCancelAction,
            style: .cancel
        )
        let settingsAction = AlertFactory.createAlertAction(
            title: AppConstants.Alerts.alertSettingsAction,
            style: .default
        ) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        let alertController = AlertFactory.createAlert(
            title: AppConstants.Alerts.noInternetAlertTitle,
            message: AppConstants.Alerts.noInternetAlertMessage,
            actions: [cancelAction, settingsAction]
        )
        present(alertController, animated: true)
    }
    
    private func showErrorAlert(error: Error) {
        let okAction = AlertFactory.createAlertAction(title: AppConstants.Alerts.allertActOk, style: .default)
        let alert = AlertFactory.createAlert(title: AppConstants.Alerts.allertTitleError, message: error.localizedDescription, actions: [okAction])
        self.present(alert, animated: true)
    }
}

// MARK: - Textfield properties

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - UIImagePickerController properties

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true)
        
        let showLocalImagesVC = ShowLocalImagesVC()
        showLocalImagesVC.selectedLocalImage = image
        showLocalImagesVC.modalPresentationStyle = .fullScreen
        present(showLocalImagesVC, animated: true)
    }
}

// MARK: - Setup UI

extension MainViewController {
    
    private func setupUI() {
        setupMainTitleLabel()
        setupSearchTextField()
        setupSearchButton()
        setupBottomInfoLabel()

        updateTFCategoryButton()
        setupKeyboardDismissGesture()
        setupOpenLocalImagesButton()
        setupOpenEditedImagesButton()
    }
    
    private func setupMainTitleLabel() {
        mainTitleLabel.text = AppConstants.MainViewController.mainTitleLabel
        mainTitleLabel.textColor = .white
        mainTitleLabel.font = UIFont(name: AppConstants.Fonts.openSansBold, size: 26)
    }
    
    private func setupSearchTextField() {
        searchTextField.delegate = self
        searchTextField.overrideUserInterfaceStyle = .light
        searchTextField.backgroundColor = .white
        searchTextField.borderStyle = .none
        searchTextField.layer.borderWidth = AppConstants.SearchTFParameters.borderWidth
        searchTextField.layer.borderColor = UIColor.hexE2E2E2.cgColor
        searchTextField.layer.cornerRadius = AppConstants.SearchTFParameters.cornerRadius
        
        searchTextField.font = UIFont(name: AppConstants.Fonts.openSansRegular, size: 18)
        
        setupPlaceHolder()
        setupIconViews()
        setupTFCategoryButton()
    }
    
    private func setupPlaceHolder() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.hex747474,
            .font: UIFont(name: AppConstants.Fonts.openSansRegular, size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(string: AppConstants.SearchTFParameters.placeHolder, attributes: attributes)
    }
    
    private func setupIconViews() {
        let searchIconView = UIView(frame: CGRect(x: .zero, y: .zero, width: 36, height: 20))
        let searchImageView = UIImageView(image: UIImage(systemName: AppConstants.ImageNames.magnifyingglass))
        searchImageView.frame = CGRect(x: 12, y: .zero, width: 20, height: 20)
        searchImageView.contentMode = .scaleAspectFit
        searchIconView.tintColor = .darkGray
        searchIconView.addSubview(searchImageView)
        
        searchTextField.leftView = searchIconView
        searchTextField.leftViewMode = .always
    }

    private func setupTFCategoryButton() {
        let separatorView = UIView(frame: CGRect(x: .zero, y: .zero, width: 1, height: searchTextField.frame.height - 27))
        separatorView.backgroundColor = UIColor.hexD2D2D2
        let separatorImage = separatorView.toImage()

        let menuButton = UIButton()
        menuButton.setImage(separatorImage, for: .normal)
        
        menuButton.setAttributedTitle(createTFRightButtonName(name: AppConstants.MainViewController.defaultCategory), for: .normal)
        menuButton.setTitleColor(UIColor.hex2D2D2D, for: .normal)
        menuButton.titleLabel?.font = UIFont(name: AppConstants.Fonts.openSansRegular, size: 14)
        menuButton.frame = CGRect(x: .zero, y: .zero, width: .zero, height: searchTextField.frame.height)
        
        menuButton.titleEdgeInsets = UIEdgeInsets(top: .zero, left: -14, bottom: .zero, right: 14)
        menuButton.imageEdgeInsets = UIEdgeInsets(top: .zero, left: -22, bottom: .zero, right: 22)
        
        menuButton.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
        
        searchTextField.rightView = menuButton
        searchTextField.rightViewMode = .always
    }
    
    private func createTFRightButtonName(name: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()

        let attachmentImage = NSTextAttachment()
        let chevronImage = UIImage(systemName: AppConstants.ImageNames.chevronDown)?.withRenderingMode(.alwaysTemplate)
        let resizedChevronImage = chevronImage?.aspectFitToSize(CGSize(width: 14, height: 14))
        attachmentImage.image = resizedChevronImage
        let attachmentString = NSAttributedString(attachment: attachmentImage)
        
        attributedString.append(NSAttributedString(string: name))
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(attachmentString)
        
        return attributedString
    }

    private func setupSearchButton() {
        searchButton.backgroundColor = UIColor.hex430BE0
        searchButton.layer.cornerRadius = 5

        searchButton.setTitle(AppConstants.ButtonTitleLabels.searchButton, for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        
        let searchImage = UIImage(systemName: AppConstants.ImageNames.magnifyingglass)
        let resizedSearchImage = searchImage?.withTintColor(.white).aspectFitToSize(CGSize(width: 17, height: 17))
        searchButton.setImage(resizedSearchImage, for: .normal)

        searchButton.titleLabel?.font = UIFont(name: AppConstants.Fonts.openSansRegular, size: 18)

        searchButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: .zero, bottom: .zero, right: 13)
        searchButton.titleEdgeInsets = UIEdgeInsets(top: .zero, left: 13, bottom: .zero, right: .zero)
    }
    
    private func setupOpenLocalImagesButton() {
        openLocalImagesButton.setTitle(AppConstants.ButtonTitleLabels.openLocalImagesButton, for: .normal)
        openLocalImagesButton.setTitleColor(.orange, for: .normal)
        
        openLocalImagesButton.layer.borderWidth = 2
        openLocalImagesButton.layer.cornerRadius = 5
        openLocalImagesButton.layer.borderColor = UIColor.orange.cgColor
    }
    
    private func setupOpenEditedImagesButton() {
        openEditedImagesButton.setTitle("Edited images", for: .normal)
        openEditedImagesButton.setTitleColor(UIColor.hex00C7BE, for: .normal)
        
        openEditedImagesButton.layer.borderWidth = 2
        openEditedImagesButton.layer.cornerRadius = 5
        openEditedImagesButton.layer.borderColor = UIColor.hex00C7BE.cgColor
    }
    
    private func customizeOpenLocalImgButton() {
        openLocalImagesButton.titleLabel?.font = UIFont(name: AppConstants.Fonts.openSansMedium, size: 18)
    }
    
    private func customizeOpenEditedImgButton() {
        openEditedImagesButton.titleLabel?.font = UIFont(name: AppConstants.Fonts.openSansMedium, size: 18)
    }
    
    private func setupBottomInfoLabel() {
        bottomInfoLabel.text = AppConstants.MainViewController.bottomInfoLabel
        bottomInfoLabel.textColor = UIColor.hexE5E5E5
        bottomInfoLabel.font = UIFont(name: AppConstants.Fonts.openSansLight, size: 12)
    }
}

// MARK: - Set Buttons Actions

extension MainViewController {
    
    @IBAction private func openEditedImagesVC(_ sender: Any) {
        let editedImagesVC = EditedImagesVC()
        editedImagesVC.modalPresentationStyle = .fullScreen
        present(editedImagesVC, animated: false)
    }
    
    @IBAction private func openLocalImages(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: false)
    }

    @IBAction private func showResults(_ sender: Any) {
        guard let pixabayDataManager = pixabayDataManager,
              let searchText = searchTextField.text else { return }
        let resultsRepresentVC = ResultsRepresentVC()
        resultsRepresentVC.pixabayDataManager = pixabayDataManager
        resultsRepresentVC.modalPresentationStyle = .fullScreen

        let request = pixabayDataManager.createSearchRequest(userRequest: searchText, selectedImageCategory, page: nil)

        pixabayDataManager.getPixabayData(request: request) { [weak resultsRepresentVC] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pixabayData):
                    resultsRepresentVC?.updateUI(with: pixabayData)
                    resultsRepresentVC?.currentSearchRequest = request
                    resultsRepresentVC?.currentSearchImageCategorie = self.selectedImageCategory
                case .failure(let error):
                    self.showErrorAlert(error: error)
                }
            }
        }
        present(resultsRepresentVC, animated: false)
    }

    @objc private func showMenu(_ sender: UIButton) {
        let menuItems: [UIAction] = [
            UIAction(title: AppConstants.MainViewController.menuCategoryVector, image: UIImage(systemName: AppConstants.ImageNames.lineDiagonalArrow), handler: { [weak self] _ in
                self?.dismissKeyboard()
                self?.selectedImageCategory = AppConstants.MainViewController.menuCategoryVector
                self?.updateTFCategoryButton()
            }),
            UIAction(title: AppConstants.MainViewController.menuCategoryIllustration, image: UIImage(systemName: AppConstants.ImageNames.photo), handler: { [weak self] _ in
                self?.dismissKeyboard()
                self?.selectedImageCategory = AppConstants.MainViewController.menuCategoryIllustration
                self?.updateTFCategoryButton()
            }),
            UIAction(title: AppConstants.MainViewController.menuCategoryPhoto, image: UIImage(systemName: AppConstants.ImageNames.camera), handler: { [weak self] _ in
                self?.dismissKeyboard()
                self?.selectedImageCategory = AppConstants.MainViewController.menuCategoryPhoto
                self?.updateTFCategoryButton()
            }),
            UIAction(title: AppConstants.MainViewController.defaultCategory, image: UIImage(systemName: AppConstants.ImageNames.photoOnRectangleAngled), handler: { [weak self] _ in
                self?.dismissKeyboard()
                self?.selectedImageCategory = AppConstants.MainViewController.defaultCategory
                self?.updateTFCategoryButton()
            })
        ]
        
        let menu = UIMenu(children: menuItems)
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
}
