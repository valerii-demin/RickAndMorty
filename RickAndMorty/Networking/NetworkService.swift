//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 12/20/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func getItems() async throws -> [Item]
    func getItem(for id: Int) async throws -> Item
    func getData(for url: URL) async throws -> Data
}

class NetworkService: NetworkServiceProtocol {
    func getItems() async throws -> [Item] {
        guard let url = URL(string: .baseURL + Endpoint.item.rawValue) else {
            throw NetworkError.invalidURL
        }
        
        let data = try await getData(for: url)

        return try JSONDecoder().decode(List.self, from: data).results
    }
    
    func getItem(for id: Int) async throws -> Item {
        guard let url = URL(string: .baseURL + Endpoint.item.rawValue + "/" + String(id)) else {
            throw NetworkError.invalidURL
        }
        
        let data = try await getData(for: url)

        return try JSONDecoder().decode(Item.self, from: data)
    }
    
    func getData(for url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.requestFailed
        }

        return data
    }
}

extension NetworkService {
    enum NetworkError: Error {
        case invalidURL
        case requestFailed
    }
}

private extension NetworkService {
    enum Endpoint: String {
        case item = "character"
    }
    
    struct List: Decodable {
        let results: [Item]
    }
}

private extension String {
    static let baseURL = "https://rickandmortyapi.com/api/"
}
