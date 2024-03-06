//
//  ResultsRepresentVC.swift
//  Images search
//
//  Created by Ivan Solohub on 28.02.2024.
//

import UIKit

class ResultsRepresentVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var separateLineView: UIView!
    @IBOutlet weak var showResultsCollectionView: UICollectionView!
    @IBOutlet weak var availableImagesInfoLabel: UILabel!
    @IBOutlet weak var relatedRequstCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - setup UI
    
    private func setupUI() {
        setupSearchTextField()
        setupFilterButton()
        setupSeparateLineView()
        setupAvailableImagesInfoLabel()
        setupRelatedRequstCollectionView()
        setupShowResultsCollectionView()
        
        setupKeyboardDismissGesture()
    }
    
    private func setupRelatedRequstCollectionView() {
        relatedRequstCollectionView.dataSource = self
        relatedRequstCollectionView.delegate = self
        relatedRequstCollectionView.register(RelatedRequstCollectionViewCellsCreator.self, forCellWithReuseIdentifier: "RelatedTagsCellId")
        relatedRequstCollectionView.accessibilityIdentifier = "RelatedRequstCollectionViewCellsCreator"
    }
    
    private func setupAvailableImagesInfoLabel() {
        availableImagesInfoLabel.text = ""
        availableImagesInfoLabel.font = UIFont(name: "OpenSans-Bold", size: 18)
    }
    
    private func setupShowResultsCollectionView() {
        showResultsCollectionView.dataSource = self
        showResultsCollectionView.delegate = self
        showResultsCollectionView.register(ShowResultsCollectionViewCellsCreator.self, forCellWithReuseIdentifier: "CellId")
        showResultsCollectionView.accessibilityIdentifier = "ShowResultsCollectionViewCellsCreator"
    }
    
    private func setupSearchTextField() {
        searchTextField.delegate = self
        searchTextField.overrideUserInterfaceStyle = .light
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = UIColor(red: 0.9647, green: 0.9647, blue: 0.9647, alpha: 1)
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.borderColorTF.cgColor
        searchTextField.layer.cornerRadius = 5
        
        searchTextField.font = UIFont(name: "OpenSans-Regular", size: 18)
        
        setupIconViews()
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
        separateLineView.backgroundColor = UIColor.separatorTFColor
    }
    
    // MARK: - Public methods
    
    func updateUI(with pixabayData: PixabayData) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let availableAmountPictures = pixabayData.total
            self.availableImagesInfoLabel.text = "\(availableAmountPictures) Free Images"
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
            return 4
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == showResultsCollectionView {
            let cell = showResultsCollectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! ShowResultsCollectionViewCellsCreator
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            return cell
        }
        else if collectionView == relatedRequstCollectionView {
            let cell = relatedRequstCollectionView.dequeueReusableCell(withReuseIdentifier: "RelatedTagsCellId", for: indexPath) as! RelatedRequstCollectionViewCellsCreator
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
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
//            let width = collectionView.frame.width - 32
//            let height = width * 0.6
            return CGSize(width: 50, height: 22)
        }
        fatalError("unsupported collection view")
    }
}
