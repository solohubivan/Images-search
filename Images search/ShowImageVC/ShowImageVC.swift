//
//  ShowImageVC.swift
//  Images search
//
//  Created by Ivan Solohub on 12.03.2024.
//

import UIKit

class ShowImageVC: UIViewController {

    @IBOutlet weak private var logoButton: UIButton!
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var filterButton: UIButton!
    @IBOutlet weak private var separateLineView: UIView!
    @IBOutlet weak private var mainImageView: UIImageView!
    @IBOutlet weak private var appLicenseLabel: UILabel!
    @IBOutlet weak private var appLicenseInfoLabel: UILabel!
    @IBOutlet weak private var pictureFormatLabel: UILabel!
    @IBOutlet weak private var shareButton: UIButton!
    @IBOutlet weak private var downloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    // MARK: - setup UI

    private func setupUI() {
        setupLogoButton()
        setupSearchTextField()
        setupFilterButton()
        setupSeparateLineView()
        setupMainImageView()
        setupAppLicenseLabel()
        setupAppLicenseInfoLabel()
        setupPictureFormatLabel()
        setupShareButton()
        setupDownloadButton()
    }
    
    private func setupLogoButton() {
        logoButton.setTitle("", for: .normal)
    }
    
    private func setupSearchTextField() {
        searchTextField.delegate = self
        searchTextField.overrideUserInterfaceStyle = .light
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = UIColor.hexF6F6F6
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.hexE2E2E2.cgColor
        searchTextField.layer.cornerRadius = 5
        
        searchTextField.font = UIFont(name: "OpenSans-Regular", size: 18)
        
        setupIconViews()
        setupPlaceHolder()
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
    
    private func setupFilterButton () {
        filterButton.setTitle("", for: .normal)
    }
    
    private func setupSeparateLineView() {
        separateLineView.backgroundColor = UIColor.hexD2D2D2
    }
    
    private func setupMainImageView() {
        mainImageView.image = UIImage(named: "backgroundPicture")
    }
    
    private func setupAppLicenseLabel() {
        appLicenseLabel.text = "APP License"
        appLicenseLabel.textColor = UIColor.hex430BE0
        appLicenseLabel.font = UIFont(name: "OpenSans-Regular", size: 16)
    }
    
    private func setupAppLicenseInfoLabel() {
        appLicenseInfoLabel.text = "Free for commercial use\nNo attribution required"
        appLicenseInfoLabel.textColor = UIColor.hex747474
        appLicenseInfoLabel.font = UIFont(name: "OpenSans-Regular", size: 15)
    }
    
    private func setupPictureFormatLabel() {
        pictureFormatLabel.text = "Photo in .JPG format"
        pictureFormatLabel.font = UIFont(name: "OpenSans-Regular", size: 15)
        pictureFormatLabel.textColor = UIColor.hex2D2D2D
    }
    
    private func setupShareButton() {
        shareButton.setTitle("", for: .normal)
    }
    
    private func setupDownloadButton() {
        downloadButton.setTitle("", for: .normal)
        downloadButton.backgroundColor = UIColor.hex430BE0
        downloadButton.layer.cornerRadius = 5
    }
    
    // MARK: - Actions
    
    @IBAction private func backToMainVC(_ sender: Any) {
        let mainVC = MainViewController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
}

// MARK: - TextField Properties

extension ShowImageVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 абвгдеєїіёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЄЇІЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ")
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 99
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        performSearch()
        return true
    }
}
