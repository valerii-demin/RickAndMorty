//
//  ListViewModel.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 12/19/24.
//

import Foundation

protocol ListViewModelProtocol {
    var list: [ListCellViewModelProtocol]? { get }
    
    func loadData() async throws
    func selectItem(at index: Int)
}

class ListViewModel: ListViewModelProtocol {
    var list: [ListCellViewModelProtocol]?
    
    private let networkService: NetworkServiceProtocol
    private let flowCoordinator: FlowCoordinatorProtocol
    private let listCellViewModelType: ListCellViewModelProtocol.Type
    
    init(networkService: NetworkServiceProtocol,
         flowCoordinator: FlowCoordinatorProtocol,
         listCellViewModelType: ListCellViewModelProtocol.Type = ListCellViewModel.self) {
        self.networkService = networkService
        self.flowCoordinator = flowCoordinator
        self.listCellViewModelType = listCellViewModelType
    }

    func loadData() async throws {
        do {
            list = try await networkService.getItems().map { item in
                listCellViewModelType.init(item: item, networkService: networkService)
            }
        } catch { }
    }
    
    func selectItem(at index: Int) {
        guard let list, list.indices.contains(index) else { return }
        
        let item = list[index]
        flowCoordinator.showDetails(for: item.id, title: item.name)
    }
}
