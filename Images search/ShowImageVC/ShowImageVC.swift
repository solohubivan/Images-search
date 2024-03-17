//
//  ShowImageVC.swift
//  Images search
//
//  Created by Ivan Solohub on 12.03.2024.
//

import UIKit
import SDWebImage

protocol ShowImageDelegate: AnyObject {
    func didPerformSearch(searchRequest: String?)
}

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
    @IBOutlet weak private var zoomButton: UIButton!
    @IBOutlet weak private var relatedImagesCollectionView: UICollectionView!
    
    var showMainImageUrl: String = ""
    var showImageVCimagesUrls: [ImageUrls] = []
    
    weak var delegate: ShowImageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let url = URL(string: showMainImageUrl) {
            updatePictureFormatLabel(with: showMainImageUrl)
            setMainImage(with: url)
        }
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
        setupZoomImageButton()
        setupRelatedImagesCollectView()
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
        mainImageView.contentMode = .scaleAspectFill
    }
    
    private func setupZoomImageButton() {
        zoomButton.setTitle("", for: .normal)
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
        pictureFormatLabel.text = "Photo in UNREAL format"
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
    
    private func setupRelatedImagesCollectView() {
        relatedImagesCollectionView.dataSource = self
        relatedImagesCollectionView.delegate = self
        relatedImagesCollectionView.register(RelatedImagesCollectionViewCellsCreator.self, forCellWithReuseIdentifier: "RelatedImagesCellId")
        relatedImagesCollectionView.accessibilityIdentifier = "RelatedImagesCollectionViewCellsCreator"
        relatedImagesCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        relatedImagesCollectionView.backgroundColor = UIColor.hexF6F6F6
    }
    
    // MARK: - Actions
    
    @IBAction private func shareFullSizeImage(_ sender: Any) {
        guard let image = mainImageView.image else { return }
        let shareViewController = ShareUtility.createShareViewController(imageToShare: image, sourceView: shareButton)
        present(shareViewController, animated: true, completion: nil)
    }
    
    @IBAction private func zoomImage(_ sender: Any) {
        if let image = mainImageView.image {
            let zoomedViewController = ZoomedImageViewController(image: image)
            zoomedViewController.modalPresentationStyle = .fullScreen
            present(zoomedViewController, animated: false)
        }
    }
    
    @IBAction private func backToResultRepresentVC(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
            
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction private func downloadTheImage(_ sender: Any) {
        guard let image = mainImageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    // MARK: - Private methods
    
    private func setMainImage(with url: URL) {
        mainImageView.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground,.progressiveLoad]) { [weak self] (image, error, cacheType, imageUrl) in
            guard let self = self else { return }
            if error == nil {
                zoomButton.isHidden = false
            }
        }
    }
    
    private func updatePictureFormatLabel(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let fileExtension = url.pathExtension.uppercased()
        pictureFormatLabel.text = "Photo in ." + fileExtension + " format"
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
        return newLength <= 90
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.didPerformSearch(searchRequest: textField.text)
        self.dismiss(animated: true)
        return true
    }
}

extension ShowImageVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showImageVCimagesUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = relatedImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "RelatedImagesCellId", for: indexPath) as! RelatedImagesCollectionViewCellsCreator
        cell.layer.masksToBounds = true
        
        let currentImageUrlString = showImageVCimagesUrls[indexPath.row].previewImageUrl
        if let url = URL(string: currentImageUrlString) {
            cell.setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 2
        let height = width * 0.6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath)

            let titleLabel = UILabel(frame: CGRect(x: 16, y: 6, width: collectionView.bounds.width - 32, height: 40))
            titleLabel.text = "Related"
            titleLabel.font = UIFont(name: "OpenSans-SemiBold", size: 20)
            headerView.addSubview(titleLabel)
            return headerView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImageUrl = showImageVCimagesUrls[indexPath.row].fullsizeImageUrl
        updatePictureFormatLabel(with: selectedImageUrl)
        if let url = URL(string: selectedImageUrl) {
            setMainImage(with: url)
        }
    }
}
