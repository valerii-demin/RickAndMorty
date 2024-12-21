//
//  Item.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 12/20/24.
//

import Foundation

struct Item: Decodable {
    let id: Int
    let name: String
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image"
    }
}
