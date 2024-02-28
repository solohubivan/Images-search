//
//  UIViewExtensions.swift
//  Images search
//
//  Created by Ivan Solohub on 28.02.2024.
//

import UIKit

extension UIView {
    
    // method to create image from UIView
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
