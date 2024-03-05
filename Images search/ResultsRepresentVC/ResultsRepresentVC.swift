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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - setup UI
    
    private func setupUI() {
        setupSearchTextField()
        setupFilterButton()
        setupSeparateLineView()
        
        setupKeyboardDismissGesture()
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
}
