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
    private var id = 0
    
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
                self.contentViewModel += result.map { ContentViewModel(id: $0.id, name: $0.name, imageURLString: $0.image)}
                self.contentView.configure(with: .init(contentViewModel: self.contentViewModel, isLoadingList: false))
            case .failure:
                print("Error")
            }
        }
    }
    
    private func uploadPhotoOnServer(image: UIImage) {
        apiService.uploadPhoto(
            idTitle: id,
            userImage: image
        ) { result in
            switch result {
            case let .success(response):
                guard let id = response?.id else { return }
                print("The image has been uploaded successfully")
                print("id = ", id)
            case .failure:
                print("Error")
            }
        }
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

// MARK: - ContentViewProtocol

extension MainViewController: ContentViewProtocol {
    func loadMoreInformation() {
        loadMoreItemsForList()
    }
    
    func openCameraFromDevice(idTitle: Int) {
        id = idTitle
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            self.uploadPhotoOnServer(image: image)
        }
    }
}
