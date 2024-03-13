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
    
    private var selectedImageCategory: String = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    // MARK: - Setup UI
    
    private func setupUI() {
        setupMainTitleLabel()
        setupSearchTextField()
        setupSearchButton()
        setupBottomInfoLabel()

        updateTFCategoryButton()
        setupKeyboardDismissGesture()
    }
    
    private func setupMainTitleLabel() {
        mainTitleLabel.text = "Take your audience on a visual adventure"
        mainTitleLabel.textColor = .white
        mainTitleLabel.font = UIFont(name: "OpenSans-Bold", size: 26)
    }
    
    private func setupSearchTextField() {
        searchTextField.delegate = self
        searchTextField.overrideUserInterfaceStyle = .light
        searchTextField.backgroundColor = .white
        searchTextField.borderStyle = .none
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.hexE2E2E2.cgColor
        searchTextField.layer.cornerRadius = 5
        
        searchTextField.font = UIFont(name: "OpenSans-Regular", size: 18)
        
        setupPlaceHolder()
        setupIconViews()
        setupTFCategoryButton()
    }
    
    private func setupPlaceHolder() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.hex747474,
            .font: UIFont(name: "OpenSans-Regular", size: 14)!
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search images, vectors and more", attributes: attributes)
    }
    
    private func setupIconViews() {
        let searchIconView = UIView(frame: CGRect(x: .zero, y: .zero, width: 36, height: 20))
        let searchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
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
        
        menuButton.setAttributedTitle(createTFRightButtonName(name: "All"), for: .normal)
        menuButton.setTitleColor(UIColor.hex2D2D2D, for: .normal)
        menuButton.titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 14)
        menuButton.frame = CGRect(x: 0, y: 0, width: 0, height: searchTextField.frame.height)
        
        menuButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 14)
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -22, bottom: 0, right: 22)
        
        menuButton.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
        
        searchTextField.rightView = menuButton
        searchTextField.rightViewMode = .always
    }
    
    private func createTFRightButtonName(name: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()

        let attachmentImage = NSTextAttachment()
        let chevronImage = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
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

        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        
        let searchImage = UIImage(systemName: "magnifyingglass")
        let resizedSearchImage = searchImage?.withTintColor(.white).aspectFitToSize(CGSize(width: 17, height: 17))
        searchButton.setImage(resizedSearchImage, for: .normal)

        searchButton.titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 18)

        searchButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 13)
        searchButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 0)
    }
    
    private func setupBottomInfoLabel() {
        bottomInfoLabel.text = "Photo by Free-Photos"
        bottomInfoLabel.textColor = UIColor.hexE5E5E5
        bottomInfoLabel.font = UIFont(name: "OpenSans-Light", size: 12)
    }
    
    // MARK: - Button actions

    @IBAction private func showResults(_ sender: Any) {
        let resultsRepresentVC = ResultsRepresentVC()
        resultsRepresentVC.modalPresentationStyle = .fullScreen
    
        let request = PixabayDataMeneger.shared.createSearchRequest(userRequest: searchTextField.text ?? "", selectedImageCategory)

        PixabayDataMeneger.shared.getPixabayData(request: request) { [weak resultsRepresentVC] pixabayData in
            resultsRepresentVC?.updateUI(with: pixabayData)
        }
        
        present(resultsRepresentVC, animated: false)
    }
    
    @objc private func showMenu(_ sender: UIButton) {
        let menuItems: [UIAction] = [
            UIAction(title: "Vector", image: UIImage(systemName: "line.diagonal.arrow"), handler: { [weak self] _ in
                self?.dismissKeyboard()
                self?.selectedImageCategory = "Vector"
                self?.updateTFCategoryButton()
            }),
            UIAction(title: "Illustration", image: UIImage(systemName: "photo"), handler: { [weak self] _ in
                self?.dismissKeyboard()
                self?.selectedImageCategory = "Illustration"
                self?.updateTFCategoryButton()
            }),
            UIAction(title: "Photo", image: UIImage(systemName: "camera"), handler: { [weak self] _ in
                self?.dismissKeyboard()
                self?.selectedImageCategory = "Photo"
                self?.updateTFCategoryButton()
            }),
            UIAction(title: "All", image: UIImage(systemName: "photo.on.rectangle.angled"), handler: { [weak self] _ in
                self?.dismissKeyboard()
                self?.selectedImageCategory = "All"
                self?.updateTFCategoryButton()
            })
        ]
        
        let menu = UIMenu(children: menuItems)
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
    
    // MARK: - Private methods

    private func updateTFCategoryButton() {
        let buttonTitle = selectedImageCategory
        let attributedString = createTFRightButtonName(name: buttonTitle)
        if let menuButton = searchTextField.rightView as? UIButton {
            menuButton.setAttributedTitle(attributedString, for: .normal)
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
