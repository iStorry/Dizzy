//
//  ImagePickerController.swift
//  Small World
//
//  Created by ジャティン on 2019/08/08.
//  Copyright © 2019 Crafts Inc. All rights reserved.
//

#if canImport(Eureka)
import Foundation
import UIKit
import Eureka
public protocol ImagePickerProtocol: class {
    var allowEditor: Bool { get set }

    var imageURL: URL? { get set }

    var useEditedImage: Bool { get set }

    var userPickerInfo: [UIImagePickerController.InfoKey: Any]? { get set }
}

/// Selector Controller used to pick an image
open class ImagePickerController: UIImagePickerController, TypedRowControllerType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /// The row that pushed or presented this controller
    public var row: RowOf<UIImage>!

    /// A closure to be called when the controller disappears.
    public var onDismissCallback: ((UIViewController) -> Void)?

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        allowsEditing = (row as? ImagePickerProtocol)?.allowEditor ?? false
        delegate = self
    }

    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        (row as? ImagePickerProtocol)?.imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL

        row.value = info[ (row as? ImagePickerProtocol)?.useEditedImage ?? false
            ? UIImagePickerController.InfoKey.editedImage
            : UIImagePickerController.InfoKey.originalImage] as? UIImage
        (row as? ImagePickerProtocol)?.userPickerInfo = info
        onDismissCallback?(self)
    }

    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        onDismissCallback?(self)
    }
}
#endif
