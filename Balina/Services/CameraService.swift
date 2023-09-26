//
//  CameraService.swift
//  Balina
//
//  Created by Roman on 9/25/23.
//

import UIKit

class AttachmentHandler: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Public Properties
    
    static let shared = AttachmentHandler()
    var imagePickedBlock: ((UIImage) -> Void)?
    
    // MARK: - Private Properties

    private var currentVC: UIViewController?
            
    // MARK: - Public Methods

    func showAttachmentActionSheet(vc: UIViewController) {
        currentVC = vc
        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        currentVC?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            currentVC?.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK: - UIImagePickerViewDelegate.
    
    func imagePickerController(
        _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        currentVC?.dismiss(animated: true) { [weak self] in
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            self?.imagePickedBlock?(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
