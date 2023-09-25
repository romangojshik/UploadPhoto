//
//  Service.swift
//  Balina
//
//  Created by Roman on 9/23/23.
//

import Foundation
import Alamofire

struct ServiceConstants {
    static let APIPath = "https://junior.balinasoft.com/api/v2/photo/"
    static let type = "type"
    static let name = "Hoishyk Roman"
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
    
    func uploadPhoto(
        id: Int,
        image: Data,
        completion: @escaping (SuccessApiResponse?, Error?) -> Void
    ) {
        let parameters = [
            "typeId": id,
            "name": ServiceConstants.name,
            "image": image
        ] as [String : AnyObject]
        AF.request(
            ServiceConstants.APIPath,
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default
        )
        .responseDecodable(of: SuccessApiResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                let error = error
                print(error.localizedDescription)
            }
        }
    }
}

