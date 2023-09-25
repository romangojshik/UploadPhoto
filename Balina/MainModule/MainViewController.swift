//
//  ViewController.swift
//  Balina
//
//  Created by Roman on 9/23/23.
//

import UIKit
import SnapKit
import Alamofire

class MainViewController: UIViewController {
    
    // MARK: - Subview Properties
    
    lazy var contentView = ContentView().then {
        $0.delegate = self
    }
    
    // MARK: - Private Properties
    
    private let apiService = APIService()
    private var currentPage : Int = 0
    private var isLoadingList : Bool = false
    private var contentViewModel: [ContentViewModel] = []
    private var userImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        addSubviews()
        makeConstraints()
        getInformationFromServer(page: 0)
    }
    
    private func addSubviews() {
        view.addSubview(contentView)
    }
    
    private func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func getInformationFromServer(page: Int) {
        apiService.getPhotoTypes(
            Content.self,
            page: page
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                guard let result = response?.content else { return }
                self.contentViewModel += result.map { ContentViewModel(id: $0.id, name: $0.name)}
                self.contentView.configure(with: .init(contentViewModel: self.contentViewModel, isLoadingList: false))
            case .failure:
                print("Eror")
            }
        }
    }
    
    private func uploadPhotoOnServer(image: UIImage) {
        let data = userImage?.jpegData(compressionQuality: 0.7)
        apiService.uploadPhoto(
            id: 1,
            image: data!,
            completion: { (response, error) in
                guard let result = response else { return }
                print("OK")
            })
    }
    
    
    private func getListFromServer(pageNumber: Int){
        self.isLoadingList = false
        getInformationFromServer(page: pageNumber)
    }
    
    private func loadMoreItemsForList(){
        currentPage += 1
        getListFromServer(pageNumber: currentPage)
    }
    
}

extension MainViewController: ContentViewProtocol {
    func loadMoreInformation() {
        loadMoreItemsForList()
    }
    
    func openCameraFromDevice(idTitle: Int) {
        showAlert()
        //        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        //        AttachmentHandler.shared.imagePickedBlock = { (image) in
        //        /* get your image here */
        //        }
    }
}

//MARK:- Image Picker

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Show alert to selected the media source type.
    private func showAlert() {
        
        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIImagePickerViewDelegate.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            // Setting image to your image view
            self?.userImage = image
            self?.uploadPhotoOnServer(image: image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
