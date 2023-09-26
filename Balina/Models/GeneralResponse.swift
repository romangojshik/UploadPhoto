//
//  GeneralResponse.swift
//  Balina
//
//  Created by Roman on 9/23/23.
//

import Foundation

class GeneralResponse<T: Codable>: Codable {
    var content: [T]
}

struct Content: Codable {
    let id: Int
    let name: String
    let image: String?
}

struct SuccessApiResponse: Codable {
    public let id: String
}
