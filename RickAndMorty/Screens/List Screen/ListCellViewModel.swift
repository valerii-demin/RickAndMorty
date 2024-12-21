//
//  ListCellViewModel.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 12/20/24.
//

import Foundation

protocol ListCellViewModelProtocol {
    var id: Int { get }
    var name: String { get }
    var image: Data { get async throws }
    
    init(item: Item, networkService: NetworkServiceProtocol)
}

class ListCellViewModel: ListCellViewModelProtocol {
    let id: Int
    let name: String
    var image: Data {
        get async throws {
            try await networkService.getData(for: imageURL)
        }
    }
    
    private let networkService: NetworkServiceProtocol
    private let imageURL: URL
    
    required init(item: Item, networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        name = item.name
        id = item.id
        imageURL = item.imageURL
    }
}
