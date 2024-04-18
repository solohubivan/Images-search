//
//  CropBuilder.swift
//  Images search
//
//  Created by Ivan Solohub on 17.04.2024.
//

import UIKit

class CropBuilder {

    static func createCropVC(with image: UIImage) -> CustomizedCropVC {
        let vc = CustomizedCropVC(croppingStyle: .default, image: image)
        vc.cancelButtonColor = .red
        vc.doneButtonTitle = AppConstants.ButtonTitleLabels.saveImage
        vc.aspectRatioPickerButtonHidden = true
        vc.rotateButtonsHidden = true
        vc.resetButtonHidden = true
        return vc
    }
}
