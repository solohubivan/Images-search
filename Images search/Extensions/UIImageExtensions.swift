//
//  UIImageExtensions.swift
//  Images search
//
//  Created by Ivan Solohub on 28.02.2024.
//

import UIKit

extension UIImage {
    
    func aspectFitToSize(_ size: CGSize) -> UIImage {
        let aspectRatio = self.size.width / self.size.height
        let scaledWidth = size.height * aspectRatio
        let scaledHeight = size.width / aspectRatio
        let targetSize: CGSize
        if scaledWidth > size.width {
            targetSize = CGSize(width: size.width, height: scaledHeight)
        } else {
            targetSize = CGSize(width: scaledWidth, height: size.height)
        }
        let scaledRect = CGRect(origin: .zero, size: targetSize)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.main.scale)
        self.draw(in: scaledRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return scaledImage
    }
}
