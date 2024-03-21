//
//  ShareUtility.swift
//  Images search
//
//  Created by Ivan Solohub on 09.03.2024.
//

import UIKit

class ShareUtility {
    static func createShareViewController(imageToShare: UIImage, sourceView: UIView) -> UIActivityViewController {
        let shareViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)

        if let popoverController = shareViewController.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
        }

        return shareViewController
    }
}
