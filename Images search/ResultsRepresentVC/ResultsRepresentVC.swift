//
//  ResultsRepresentVC.swift
//  Images search
//
//  Created by Ivan Solohub on 28.02.2024.
//

import UIKit

class ResultsRepresentVC: UIViewController {

    @IBOutlet weak private var logoButton: UIButton!
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var filterButton: UIButton!
    @IBOutlet weak private var separateLineView: UIView!
    @IBOutlet weak private var showResultsCollectionView: UICollectionView!
    @IBOutlet weak private var availableImagesInfoLabel: UILabel!
    @IBOutlet weak private var relatedRequstCollectionView: UICollectionView!
    @IBOutlet weak private var relatedLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    
    private var relatedResultsLabels: [String] = []
    private var imageUrls: [ImageViewModelData] = []
    private var currentPage = Constants.currentPage
    
    var currentSearchRequest: String?
    var currentSearchImageCategorie: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setActivityIndicatorHidden(false)
    }
    
    // MARK: - Orientation settings

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.showResultsCollectionView.collectionViewLayout.invalidateLayout()
        })
    }

    // MARK: - setup UI
    
    private func setupUI() {
        setupLogoButton()
        setupSearchTextField()
        setupFilterButton()
        setupSeparateLineView()
        setupAvailableImagesInfoLabel()
        setupRelatedRequstCollectionView()
        setupShowResultsCollectionView()
        setupRelatedLabel()
        setupActivityIndicator()
        
        view.backgroundColor = UIColor.hexF6F6F6
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
        searchTextField.layer.borderWidth = AppConstants.SearchTFParameters.borderWidth
        searchTextField.layer.borderColor = UIColor.hexE2E2E2.cgColor
        searchTextField.layer.cornerRadius = AppConstants.SearchTFParameters.cornerRadius
        
        searchTextField.font = UIFont(name: AppConstants.Fonts.openSansRegular, size: 18)
        
        setupIconViews()
        setupPlaceHolder()
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
    
    private func setupFilterButton () {
        filterButton.setTitle("", for: .normal)
        filterButton.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
    }
    
    private func setupSeparateLineView() {
        separateLineView.backgroundColor = UIColor.hexD2D2D2
    }
    
    private func setupAvailableImagesInfoLabel() {
        availableImagesInfoLabel.text = ""
        availableImagesInfoLabel.font = UIFont(name: AppConstants.Fonts.openSansSemibold, size: 20)
        availableImagesInfoLabel.textColor = .black
    }
    
    private func setupRelatedLabel() {
        relatedLabel.text = AppConstants.ResultRepresentVC.relatedLabelText
        relatedLabel.font = UIFont(name: AppConstants.Fonts.openSansRegular, size: 16)
        relatedLabel.textColor = UIColor.hex747474
    }
    
    private func setupRelatedRequstCollectionView() {
        relatedRequstCollectionView.dataSource = self
        relatedRequstCollectionView.delegate = self
        relatedRequstCollectionView.register(RelatedRequstCollectionViewCellsCreator.self, forCellWithReuseIdentifier: AppConstants.CollectionViewCellsId.relatedCellsID)
        relatedRequstCollectionView.accessibilityIdentifier = AppConstants.CollectionViewCellsId.relatedCellsCreator
        relatedRequstCollectionView.backgroundColor = .clear
    }
    
    private func setupShowResultsCollectionView() {
        showResultsCollectionView.dataSource = self
        showResultsCollectionView.delegate = self
        showResultsCollectionView.register(ShowResultsCollectionViewCellsCreator.self, forCellWithReuseIdentifier: AppConstants.CollectionViewCellsId.showResultImageCellsID)
        showResultsCollectionView.accessibilityIdentifier = AppConstants.CollectionViewCellsId.showResultImageCellsCreator
        showResultsCollectionView.backgroundColor = .clear
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    // MARK: - Actions
    
    @IBAction private func backToMainVC(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
            
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func showMenu(_ sender: UIButton) {
        let sortActionMenu = UIMenu(title: AppConstants.ResultRepresentVC.menuTitle, options: .displayInline, children: [
            UIAction(title: AppConstants.ResultRepresentVC.menuItemDownloads, image: UIImage(systemName: AppConstants.ImageNames.arrowDownCircle), handler: { [weak self] _ in
                guard let self = self else { return }
                self.imageUrls.sort { $0.downloads > $1.downloads }
                self.showResultsCollectionView.reloadData()
            }),
            UIAction(title: AppConstants.ResultRepresentVC.menuItemLikes, image: UIImage(systemName: AppConstants.ImageNames.handThumbsup), handler: { [weak self] _ in
                guard let self = self else { return }
                self.imageUrls.sort { $0.likes > $1.likes }
                self.showResultsCollectionView.reloadData()
            }),
            UIAction(title: AppConstants.ResultRepresentVC.menuItemViews, image: UIImage(systemName: AppConstants.ImageNames.eye), handler: { [weak self] _ in
                guard let self = self else { return }
                self.imageUrls.sort { $0.views > $1.views }
                self.showResultsCollectionView.reloadData()
            }),
            UIAction(title: AppConstants.ResultRepresentVC.menuItemComments, image: UIImage(systemName: AppConstants.ImageNames.ellipsisMessage), handler: { [weak self] _ in
                guard let self = self else { return }
                self.imageUrls.sort { $0.comments > $1.comments }
                self.showResultsCollectionView.reloadData()
            })
        ])
        
        let cancelAction = UIAction(title: AppConstants.ResultRepresentVC.menuItemCancel, image: UIImage(systemName: AppConstants.ImageNames.xmarkApp), attributes: .destructive, handler: { _ in })

        let menu = UIMenu(children: [sortActionMenu, cancelAction])
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
    
    // MARK: - Public methods
    
    func updateUI(with pixabayData: PixabayData) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let availableAmountPictures = pixabayData.total
            let formattedNumber = NumberFormatter.formatNumberWithSpaces(availableAmountPictures)
            self.availableImagesInfoLabel.text = "\(formattedNumber) \(AppConstants.ResultRepresentVC.availableImagesInfo)"
            
            self.relatedResultsLabels = PixabayDataManager.shared.creatingRelatedStrings()
            self.imageUrls = PixabayDataManager.shared.getImageViewModelData()

            self.relatedRequstCollectionView.reloadData()
            self.showResultsCollectionView.reloadData()
            
            if self.showResultsCollectionView.numberOfSections > .zero && self.showResultsCollectionView.numberOfItems(inSection: .zero) > .zero {
                let indexPath = IndexPath(item: .zero, section: .zero)
                self.showResultsCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            }
            self.setActivityIndicatorHidden(true)
        }
    }
    
    // MARK: - Private methods

    private func setActivityIndicatorHidden(_ isHidden: Bool) {
        if isHidden {
            activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
        } else {
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        }
    }
    
    private func performSearch(searchRequest: String?) {
        guard let searchText = searchRequest, !searchText.isEmpty else { return }
        currentSearchRequest = searchText
        currentPage = 1
        setActivityIndicatorHidden(false)

        let request = PixabayDataManager.shared.createSearchRequest(userRequest: searchText, currentSearchImageCategorie ?? AppConstants.ResultRepresentVC.searchImageDefaultCategorie, page: currentPage)
        PixabayDataManager.shared.getPixabayData(request: request) { [weak self] pixabayData in
            self?.updateUI(with: pixabayData)
        }
    }

    private func loadMoreImages() {
        currentPage += 1
        let request = PixabayDataManager.shared.createSearchRequest(userRequest: currentSearchRequest ?? "", currentSearchImageCategorie ?? AppConstants.ResultRepresentVC.searchImageDefaultCategorie, page: currentPage)
        PixabayDataManager.shared.getPixabayData(request: request) { [weak self] pixabayData in
            guard let self = self else { return }
            let newImageUrls = PixabayDataManager.shared.getImageViewModelData()
            DispatchQueue.main.async {
                self.imageUrls.append(contentsOf: newImageUrls)
                self.showResultsCollectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionView properties

extension ResultsRepresentVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
        if collectionView == showResultsCollectionView {
            return imageUrls.count
        } else if collectionView == relatedRequstCollectionView {
            return relatedResultsLabels.count
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == showResultsCollectionView {
            let cell = showResultsCollectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.CollectionViewCellsId.showResultImageCellsID, for: indexPath) as! ShowResultsCollectionViewCellsCreator
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true

            let currentImageUrlString = imageUrls[indexPath.row].previewImageUrl
            if let url = URL(string: currentImageUrlString) {
                cell.setImage(with: url)
            }
            cell.parentViewController = self
            return cell
            
        } else if collectionView == relatedRequstCollectionView {
            let cell = relatedRequstCollectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.CollectionViewCellsId.relatedCellsID, for: indexPath) as! RelatedRequstCollectionViewCellsCreator
            cell.relatedTags.text = relatedResultsLabels[indexPath.item]
            return cell
        }
        fatalError("unsupported collection view")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == showResultsCollectionView {
            let padding: CGFloat = 32
            let minimumItemSpacing: CGFloat = 16
            
            var itemsPerRow: CGFloat
            if UIDevice.current.orientation.isLandscape {
                itemsPerRow = 3
            } else {
                itemsPerRow = 1
            }
            
            let availableWidth = collectionView.frame.width - padding - (minimumItemSpacing * (itemsPerRow - 1))
            let widthPerItem = availableWidth / itemsPerRow
            let heightPerItem = widthPerItem * 0.6
            
            return CGSize(width: widthPerItem, height: heightPerItem)
            
        } else if collectionView == relatedRequstCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.CollectionViewCellsId.relatedCellsID, for: indexPath) as? RelatedRequstCollectionViewCellsCreator else { return CGSize.zero }
            cell.relatedTags.text = relatedResultsLabels[indexPath.item]

            let size = cell.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingCompressedSize.height))
            return CGSize(width: size.width, height: size.height + 7)
        }
        fatalError("unsupported collection view")
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == showResultsCollectionView {
            let selectedImageUrl = imageUrls[indexPath.row].fullsizeImageUrl
            let showImageVC = ShowImageVC()
            showImageVC.delegate = self
            showImageVC.showMainImageUrl = selectedImageUrl
            showImageVC.showImageVCimagesUrls = self.imageUrls
            showImageVC.modalPresentationStyle = .fullScreen
            present(showImageVC, animated: false)
            
        } else if collectionView == relatedRequstCollectionView {
            let selectedItem = relatedResultsLabels[indexPath.row]
            performSearch(searchRequest: selectedItem)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == showResultsCollectionView {
            let lastSectionIndex = collectionView.numberOfSections - 1
            let lastItemIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
            if indexPath.section == lastSectionIndex && indexPath.item == lastItemIndex {
                loadMoreImages()
            }
        }
    }
}

// MARK: - TextField Properties

extension ResultsRepresentVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 абвгдеєїіёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЄЇІЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ")
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= Constants.availableSymbolsToInputTF
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performSearch(searchRequest: textField.text)
        textField.text = ""
        return true
    }
}

// MARK: - delegate

extension ResultsRepresentVC: ShowImageDelegate {
    func didPerformSearch(searchRequest: String?) {
        performSearch(searchRequest: searchRequest)
    }
}

// MARK: - Constants

extension ResultsRepresentVC {
    private enum Constants {
        static let currentPage: Int = 1
        static let availableSymbolsToInputTF: Int = 90
    }
}
