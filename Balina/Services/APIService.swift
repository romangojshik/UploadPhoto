//
//  Service.swift
//  Balina
//
//  Created by Roman on 9/23/23.
//

import Foundation
import Alamofire

struct ServiceConstants {
    static let APIPath = "https://junior.balinasoft.com/api/v2/photo"
    static let type = "/type"
    static let userName = "Hoishyk Roman"
}

class APIService {
    func getPhotoTypes<T: Codable>(
        _ objectType: T.Type,
        page: Int,
        completion: @escaping (Result<GeneralResponse<T>?, Error>) -> Void
    ) {
        let parameters = ["page": page]
        AF.request(
            ServiceConstants.APIPath + ServiceConstants.type,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default
        )
        .responseDecodable(of: GeneralResponse<T>.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                let error = error
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadPhoto(idTitle: Int, userImage: UIImage, completion: @escaping (Result<SuccessApiResponse?, Error>) -> Void) {
        let url = ServiceConstants.APIPath
        guard let imageData = userImage.jpegData(compressionQuality: 0.5) else { return }
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        let params = ["name": ServiceConstants.userName, "typeId" : idTitle] as [String: AnyObject]
        AF.upload(multipartFormData: { multiPart in
            for (key, keyValue) in params {
                 if keyValue is String || keyValue is Int {
                    if let keyData = "\(keyValue)".data(using: .utf8) {
                        multiPart.append(keyData, withName: key)
                    }
                 }
             }
            multiPart.append(imageData, withName: "photo", fileName: "fileName.jpg", mimeType: "image/jpeg")
        }, to: url, headers: headers).responseDecodable(of: SuccessApiResponse.self) { response in
            switch response.result {
            case .success(let data):
                guard let apiDictionary = response.value else { return }
                print("apiResponse --- \(apiDictionary)")
                completion(.success(data))
            case .failure(let error):
                let error = error
                print(error.localizedDescription)
            }
        }
    }
}
