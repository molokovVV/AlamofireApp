//
//  Alamofire.swift
//  AlamofireApp
//
//  Created by Виталик Молоков on 30.03.2023.
//

import Foundation

struct Card: Codable {
    let name: String?
    let imageUrl: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
            case name
            case type
            case imageUrl = "imageUrl"
        }
}
