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
    private var imageUrls: [ImageUrls] = []
    private var currentPage = 1
    
    var currentSearchRequest: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setActivityIndicatorHidden(false)
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
        filterButton.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
    }
    
    private func setupSeparateLineView() {
        separateLineView.backgroundColor = UIColor.hexD2D2D2
    }
    
    private func setupAvailableImagesInfoLabel() {
        availableImagesInfoLabel.text = ""
        availableImagesInfoLabel.font = UIFont(name: "OpenSans-Semibold", size: 20)
    }
    
    private func setupRelatedLabel() {
        relatedLabel.text = "Related"
        relatedLabel.font = UIFont(name: "OpenSans-Regular", size: 16)
        relatedLabel.textColor = UIColor.hex747474
    }
    
    private func setupRelatedRequstCollectionView() {
        relatedRequstCollectionView.dataSource = self
        relatedRequstCollectionView.delegate = self
        relatedRequstCollectionView.register(RelatedRequstCollectionViewCellsCreator.self, forCellWithReuseIdentifier: "RelatedTagsCellId")
        relatedRequstCollectionView.accessibilityIdentifier = "RelatedRequstCollectionViewCellsCreator"
        relatedRequstCollectionView.backgroundColor = .clear
    }
    
    private func setupShowResultsCollectionView() {
        showResultsCollectionView.dataSource = self
        showResultsCollectionView.delegate = self
        showResultsCollectionView.register(ShowResultsCollectionViewCellsCreator.self, forCellWithReuseIdentifier: "CellId")
        showResultsCollectionView.accessibilityIdentifier = "ShowResultsCollectionViewCellsCreator"
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
        let sortActionMenu = UIMenu(title: "Sort by person action", options: .displayInline, children: [
            UIAction(title: "Downloads", image: UIImage(systemName: "arrow.down.circle"), handler: { _ in
                print("tapped downloads")
            }),
            UIAction(title: "Likes", image: UIImage(systemName: "hand.thumbsup"), handler: { _ in
                print("choosed Likes")
            }),
            UIAction(title: "Views", image: UIImage(systemName: "eye"), handler: { _ in
                print("choosed views")
            }),
            UIAction(title: "Comments", image: UIImage(systemName: "ellipsis.message"), handler: { _ in
                print("choosed comments")
            })
        ])
        
        let cancelAction = UIAction(title: "Cancel", image: UIImage(systemName: "xmark.app"), attributes: .destructive, handler: { _ in })

        let menu = UIMenu(children: [sortActionMenu, cancelAction])
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
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

        let request = PixabayDataMeneger.shared.createSearchRequest(userRequest: searchText, "all", page: currentPage)
        PixabayDataMeneger.shared.getPixabayData(request: request) { [weak self] pixabayData in
            self?.updateUI(with: pixabayData)
        }
    }

    private func loadMoreImages() {
        currentPage += 1
        let request = PixabayDataMeneger.shared.createSearchRequest(userRequest: currentSearchRequest ?? "", "all", page: currentPage)
        PixabayDataMeneger.shared.getPixabayData(request: request) { [weak self] pixabayData in
            guard let self = self else { return }
            let newImageUrls = PixabayDataMeneger.shared.getImageViewModelData()
            DispatchQueue.main.async {
                self.imageUrls.append(contentsOf: newImageUrls)
                self.showResultsCollectionView.reloadData()
            }
        }
    }

    // MARK: - Public methods
    
    func updateUI(with pixabayData: PixabayData) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let availableAmountPictures = pixabayData.total
            let formattedNumber = NumberFormatter.formatNumberWithSpaces(availableAmountPictures)
            self.availableImagesInfoLabel.text = "\(formattedNumber) Free Images"
            
            self.relatedResultsLabels = PixabayDataMeneger.shared.creatingRelatedStrings()
            self.imageUrls = PixabayDataMeneger.shared.getImageViewModelData()

            self.relatedRequstCollectionView.reloadData()
            self.showResultsCollectionView.reloadData()
            
            if self.showResultsCollectionView.numberOfSections > 0 && self.showResultsCollectionView.numberOfItems(inSection: 0) > 0 {
                let indexPath = IndexPath(item: 0, section: 0)
                self.showResultsCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            }
            
            self.setActivityIndicatorHidden(true)
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
            let cell = showResultsCollectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! ShowResultsCollectionViewCellsCreator
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
            let cell = relatedRequstCollectionView.dequeueReusableCell(withReuseIdentifier: "RelatedTagsCellId", for: indexPath) as! RelatedRequstCollectionViewCellsCreator
            cell.relatedTags.text = relatedResultsLabels[indexPath.item]
            return cell
        }
        fatalError("unsupported collection view")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == showResultsCollectionView {
            let width = collectionView.frame.width - 32
            let height = width * 0.6
            return CGSize(width: width, height: height)
            
        } else if collectionView == relatedRequstCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedTagsCellId", for: indexPath) as? RelatedRequstCollectionViewCellsCreator else { return CGSize.zero }
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
        return newLength <= 99
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performSearch(searchRequest: textField.text)
        return true
    }
}

// MARK: - delegate

extension ResultsRepresentVC: ShowImageDelegate {
    func didPerformSearch(searchRequest: String?) {
        performSearch(searchRequest: searchRequest)
    }
}
