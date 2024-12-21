//
//  DetailsViewModel.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 12/19/24.
//

import Foundation

protocol DetailsViewModelProtocol {
    var image: Data? { get async throws }
    
    func loadData() async throws
}

class DetailsViewModel: DetailsViewModelProtocol {
    var image: Data? {
        get async throws {
            guard let url = item?.imageURL else { return nil }
            
            return try await networkService.getData(for: url)
        }
    }
    
    private let id: Int
    private let networkService: NetworkServiceProtocol
    private var item: Item?
    
    init(with id: Int, networkService: NetworkServiceProtocol) {
        self.id = id
        self.networkService = networkService
    }
    
    func loadData() async throws {
        do {
            item = try await networkService.getItem(for: id)
        } catch (let error) {
            throw error
        }
    }
}
