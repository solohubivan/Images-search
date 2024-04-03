//
//  AppConstants.swift
//  Images search
//
//  Created by Ivan Solohub on 18.03.2024.
//

import Foundation

enum AppConstants {
    
    enum Alerts {
        static let noInternetAlertTitle: String = "Internet connection is unavailable"
        static let noInternetAlertMessage: String = "please allow this app to internet access"
        static let alertCancelAction: String = "Cancel"
        static let alertSettingsAction: String = "Settings"
        static let requestFilteredAlertTitle: String = "All your request is filtered"
        static let requestFilteredAlertMessage: String = "Please customize filters or change request"
        static let allertActOk: String = "OK"
        static let allertTitleSaveError: String = "Save error"
        static let allertTitleError: String = "Error"
        static let allertTitleSaved: String = "Saved"
        static let allertMessageSaved: String = "Your image has been saved to your photos"
    }
    
    enum Fonts {
        static let openSansBold = "OpenSans-Bold"
        static let openSansRegular = "OpenSans-Regular"
        static let openSansLight = "OpenSans-Light"
        static let openSansSemibold = "OpenSans-Semibold"
        static let openSansMedium = "OpenSans-Medium"
    }
    
    enum ImageNames {
        static let chevronDown: String = "chevron.down"
        static let magnifyingglass: String = "magnifyingglass"
        static let lineDiagonalArrow: String = "line.diagonal.arrow"
        static let photo: String = "photo"
        static let camera: String = "camera"
        static let photoOnRectangleAngled: String = "photo.on.rectangle.angled"
        static let arrowDownCircle: String = "arrow.down.circle"
        static let handThumbsup: String = "hand.thumbsup"
        static let eye: String = "eye"
        static let ellipsisMessage: String = "ellipsis.message"
        static let xmarkApp: String = "xmark.app"
        static let share: String = "share"
        static let squareAndArrow: String = "square.and.arrow.up"
        static let cropRotate: String = "crop.rotate"
        static let trash: String = "trash"
    }
    
    enum ButtonTitleLabels {
        static let searchButton: String = "Search"
        static let openLocalImagesButton: String = "Open local images"
        static let editButton: String = "Edit"
        static let editedImages: String = "Edited images"
        static let editImage: String = "Edit image"
    }
    
    enum SearchTFParameters {
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 5
        static let placeHolder: String = "Search images, vectors and more"
    }
    
    enum MainViewController {
        static let mainTitleLabel: String = "Take your audience on a visual adventure"
        static let bottomInfoLabel: String = "Photo by Free-Photos"
        static let defaultCategory: String = "All"
        static let menuCategoryVector: String = "Vector"
        static let menuCategoryIllustration: String = "Illustration"
        static let menuCategoryPhoto: String = "Photo"
        static let editedImages: String = "Edited images"
    }
    
    enum ResultRepresentVC {
        static let relatedLabelText: String = "Related"
        static let searchImageDefaultCategorie: String = "all"
        static let availableImagesInfo: String = "Free Images"
        static let menuTitle: String = "Sort by person action"
        static let menuItemDownloads: String = "Downloads"
        static let menuItemLikes: String = "Likes"
        static let menuItemViews: String = "Views"
        static let menuItemComments: String = "Comments"
        static let menuItemCancel: String = "Cancel"
    }
    
    enum ShowImageVC {
        static let appLicenseLabelText: String = "APP License"
        static let appLicenseInfoLabelText: String = "Free for commercial use\nNo attribution required"
        static let relatedLabelText: String = "Related"
        static let relatedImagesCellsID: String = "RelatedImagesCellId"
        static let relatedImagesCellsCreator: String = "RelatedImagesCollectionViewCellsCreator"
        static let relatedImagesCellsHeader: String = "SectionHeader"
        static let editedImages: String = "Edited images"
    }
    
    enum EditedImagesVC {
        static let actionTitleShare: String = "Share"
        static let actionTitleEditImage: String = "Edit image"
        static let actionTitleDelete: String = "Delete"
        static let titleLabelEditedImages: String = "Edited images"
        static let noImagesAlertLabel: String = "No edited images yet!"
    }
    
    enum CollectionViewCellsId {
        static let relatedCellsID: String = "RelatedTagsCellId"
        static let relatedCellsCreator: String = "RelatedRequstCollectionViewCellsCreator"
        static let showResultImageCellsID: String = "CellId"
        static let showResultImageCellsCreator: String = "ShowResultsCollectionViewCellsCreator"
        static let localImagePreviewCellId: String = "LocalImagePreviewCellId"
        static let editedImagesCellID: String = "EditedImagesCellID"
    }
    
    enum EditedImagesDataManager {
        static let imageFileExtension = "jpeg"
    }
}
