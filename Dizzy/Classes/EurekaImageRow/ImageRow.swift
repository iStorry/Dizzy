//
//  ImageRow.swift
//  Small World
//
//  Created by ジャティン on 2019/08/08.
//  Copyright © 2019 Crafts Inc. All rights reserved.
//

#if canImport(Eureka)
import Foundation
import UIKit
import Eureka
public struct ImageRowSourceTypes: OptionSet {
    public let rawValue: Int
    public var imagePickerControllerSourceTypeRawValue: Int { return self.rawValue >> 1 }

    public init(rawValue: Int) { self.rawValue = rawValue }
    init(_ sourceType: UIImagePickerController.SourceType) { self.init(rawValue: 1 << sourceType.rawValue) }

    public static let PhotoLibrary = ImageRowSourceTypes(.photoLibrary)
    public static let Camera = ImageRowSourceTypes(.camera)
    public static let SavedPhotosAlbum = ImageRowSourceTypes(.savedPhotosAlbum)
    public static let all: ImageRowSourceTypes = [Camera, PhotoLibrary]
}

public extension ImageRowSourceTypes {
    var localizedString: String {
        switch self {
        case ImageRowSourceTypes.Camera:
            return NSLocalizedString("Take Photo", comment: "")
        case ImageRowSourceTypes.PhotoLibrary:
            return NSLocalizedString("Photo Library", comment: "")
        case ImageRowSourceTypes.SavedPhotosAlbum:
            return NSLocalizedString("Saved Photos", comment: "")
        default:
            return ""
        }
    }
}

public enum ImageClearAction {
    case no
    case yes(style: UIAlertAction.Style)
}

public protocol ImageRowProtocol {
    var placeholderImage: UIImage? { get }
}

// MARK: Row
// swiftlint:disable type_name
open class _ImageRow<Cell: CellType>: OptionsRow<Cell>, PresenterRowType, ImageRowProtocol, ImagePickerProtocol where Cell: BaseCell, Cell.Value == UIImage {
    // swiftlint:enable type_name
    public typealias PresenterRow = ImagePickerController

    /// Defines how the view controller will be presented, pushed, etc.
    open var presentationMode: PresentationMode<PresenterRow>?

    /// Will be called before the presentation occurs.
    open var onPresentCallback: ((FormViewController, PresenterRow) -> Void)?

    open var sourceTypes: ImageRowSourceTypes
    open var imageURL: URL?
    open var clearAction = ImageClearAction.yes(style: .destructive)
    open var placeholderImage: UIImage?

    open var userPickerInfo: [UIImagePickerController.InfoKey: Any]?
    open var allowEditor: Bool
    open var useEditedImage: Bool

    private var _sourceType: UIImagePickerController.SourceType = .camera

    public required init(tag: String?) {
        sourceTypes = .all
        userPickerInfo = nil
        allowEditor = false
        useEditedImage = false

        super.init(tag: tag)

        presentationMode = .presentModally(controllerProvider: ControllerProvider.callback { return ImagePickerController() }, onDismiss: { [weak self] vc in
            self?.select()
            vc.dismiss(animated: true)
        })

        self.displayValueFor = nil
    }

    // copy over the existing logic from the SelectorRow
    func displayImagePickerController(_ sourceType: UIImagePickerController.SourceType) {
        if let presentationMode = presentationMode, !isDisabled {
            if let controller = presentationMode.makeController() {
                controller.row = self
                controller.sourceType = sourceType
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.present(controller, row: self, presentingController: cell.formViewController()!)
            } else {
                _sourceType = sourceType
                presentationMode.present(nil, row: self, presentingController: cell.formViewController()!)
            }
        }
    }

    /// Extends `didSelect` method
    /// Selecting the Image Row cell will open a popup to choose where to source the photo from,
    /// based on the `sourceTypes` configured and the available sources.
    open override func customDidSelect() {
        guard !isDisabled else {
            super.customDidSelect()
            return
        }

        deselect()
        selectSource()
    }
    // swiftlint:disable cyclomatic_complexity
    open func selectSource() {
        var availableSources: ImageRowSourceTypes = []

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            _ = availableSources.insert(.PhotoLibrary)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            _ = availableSources.insert(.Camera)
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            _ = availableSources.insert(.SavedPhotosAlbum)
        }

        sourceTypes.formIntersection(availableSources)

        if sourceTypes.isEmpty {
            super.customDidSelect()
            guard let presentationMode = presentationMode else { return }

            if let controller = presentationMode.makeController() {
                controller.row = self
                controller.title = selectorTitle ?? controller.title
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
            } else {
                presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
            }

            return
        }

        // Now that we know the number of sources aren't empty, let the user select the source
        let sourceActionSheet = UIAlertController(title: nil, message: selectorTitle, preferredStyle: .actionSheet)

        guard let tableView = cell.formViewController()?.tableView  else { fatalError() }

        if let popView = sourceActionSheet.popoverPresentationController {
            popView.sourceView = tableView
            popView.sourceRect = tableView.convert(cell.accessoryView?.frame ?? cell.contentView.frame, from: cell)
        }

        createOptionsForAlertController(sourceActionSheet)

        if case .yes(let style) = clearAction, value != nil {
            let clearPhotoOption = UIAlertAction(title: NSLocalizedString("Clear Photo", comment: ""), style: style) { [weak self] _ in
                self?.value = nil
                self?.imageURL = nil
                self?.updateCell()
            }

            sourceActionSheet.addAction(clearPhotoOption)
        }

        if sourceActionSheet.actions.count == 1 {
            if let imagePickerSourceType = UIImagePickerController.SourceType(rawValue: sourceTypes.imagePickerControllerSourceTypeRawValue) {
                displayImagePickerController(imagePickerSourceType)
            }
        } else {
            let cancelOption = UIAlertAction(title: NSLocalizedString("キャンセル", comment: ""), style: .cancel, handler: nil)

            sourceActionSheet.addAction(cancelOption)

            if let presentingViewController = cell.formViewController() {
                presentingViewController.present(sourceActionSheet, animated: true)
            }
        }
    }
    // swiftlint:enable cyclomatic_complexity
    /**
     Prepares the pushed row setting its title and completion callback.
     */
    open override func prepare(for segue: UIStoryboardSegue) {
        super.prepare(for: segue)
        guard let rowVC = segue.destination as? PresenterRow else { return }
        rowVC.title = selectorTitle ?? rowVC.title
        rowVC.onDismissCallback = presentationMode?.onDismissCallback ?? rowVC.onDismissCallback
        onPresentCallback?(cell.formViewController()!, rowVC)
        rowVC.row = self
        rowVC.sourceType = _sourceType
    }
}

public extension _ImageRow {
    func createOptionForAlertController(_ alertController: UIAlertController, sourceType: ImageRowSourceTypes) {
        guard let pickerSourceType = UIImagePickerController.SourceType(
            rawValue: sourceType.imagePickerControllerSourceTypeRawValue),
            sourceTypes.contains(sourceType) else { return }

        let option = UIAlertAction(title: NSLocalizedString(sourceType.localizedString, comment: ""), style: .default) { [weak self] _ in
            self?.displayImagePickerController(pickerSourceType)
        }

        alertController.addAction(option)
    }

    func createOptionsForAlertController(_ alertController: UIAlertController) {
        createOptionForAlertController(alertController, sourceType: .Camera)
        createOptionForAlertController(alertController, sourceType: .PhotoLibrary)
        createOptionForAlertController(alertController, sourceType: .SavedPhotosAlbum)
    }
}

/// A selector row where the user can pick an image
public final class ImageRow: _ImageRow<ImageCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}
#endif
