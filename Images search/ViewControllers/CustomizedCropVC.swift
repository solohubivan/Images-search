//
//  CustomizedCropVC.swift
//  Images search
//
//  Created by Ivan Solohub on 17.04.2024.
//

import UIKit
import TOCropViewController

class CustomizedCropVC: TOCropViewController, TOCropViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupCustomUI()
    }
    
    // MARK: - setupUI
    
    private func setupCustomUI() {
        self.view.backgroundColor = UIColor.hexF6F6F6
        self.cropView.backgroundColor = .clear
        self.cropView.translucencyAlwaysHidden = true
        self.toolbarPosition = .bottom
    }
    
    // MARK: - TOCropViewController properties
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        EditedImagesDataManager.shared.saveEditedImage(image)
    }
}
