//
//  ResultsRepresentVC.swift
//  Images search
//
//  Created by Ivan Solohub on 28.02.2024.
//

import UIKit

class ResultsRepresentVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var filterButton: UIButton!
    @IBOutlet weak private var separateLineView: UIView!
    @IBOutlet weak private var showResultsCollectionView: UICollectionView!
    @IBOutlet weak private var availableImagesInfoLabel: UILabel!
    @IBOutlet weak private var relatedRequstCollectionView: UICollectionView!
    @IBOutlet weak private var relatedLabel: UILabel!
    @IBOutlet weak private var backGroundView: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    
    private var relatedResultsLabels: [String] = []
    private var previewImageUrls: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setActivityIndicatorHidden(false)
    }
    
    // MARK: - setup UI
    
    private func setupUI() {
        setupSearchTextField()
        setupFilterButton()
        setupSeparateLineView()
        setupAvailableImagesInfoLabel()
        setupRelatedRequstCollectionView()
        setupShowResultsCollectionView()
        setupRelatedLabel()
        setupActivityIndicator()
        
        setupKeyboardDismissGesture()
        backGroundView.backgroundColor = UIColor.hexF6F6F6
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setupRelatedLabel() {
        relatedLabel.text = "Related"
        relatedLabel.font = UIFont(name: "OpenSans-Regular", size: 16)
        relatedLabel.textColor = UIColor.hex747474
    }

    private func setupAvailableImagesInfoLabel() {
        availableImagesInfoLabel.text = ""
        availableImagesInfoLabel.font = UIFont(name: "OpenSans-Semibold", size: 20)
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
    
    // MARK: - Public methods
    
    func updateUI(with pixabayData: PixabayData) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let availableAmountPictures = pixabayData.total
            self.availableImagesInfoLabel.text = "\(availableAmountPictures) Free Images"
            
            self.relatedResultsLabels = PixabayDataMeneger.shared.creatingRelatedStrings()
            
            self.previewImageUrls = PixabayDataMeneger.shared.getLinksToPreviewImages()

            self.relatedRequstCollectionView.reloadData()
            self.showResultsCollectionView.reloadData()
            
            self.setActivityIndicatorHidden(true)
        }
    }
}

// MARK: - UICollectionView properties

extension ResultsRepresentVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == showResultsCollectionView {
            return PixabayDataMeneger.shared.getFoundImagesCount()
        }
        else if collectionView == relatedRequstCollectionView {
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

            let currentImageUrlString = previewImageUrls[indexPath.row]
            if let url = URL(string: currentImageUrlString) {
                cell.setImage(with: url)
            }
            cell.parentViewController = self
            return cell
        }
        else if collectionView == relatedRequstCollectionView {
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
        }
        else if collectionView == relatedRequstCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedTagsCellId", for: indexPath) as? RelatedRequstCollectionViewCellsCreator else {
                return CGSize.zero
            }
            cell.relatedTags.text = relatedResultsLabels[indexPath.item]
            let size = cell.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingCompressedSize.height))
            return CGSize(width: size.width, height: size.height + 7)
        }
        fatalError("unsupported collection view")
    }
}
