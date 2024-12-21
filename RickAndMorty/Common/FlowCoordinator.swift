//
//  FlowCoordinator.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 12/19/24.
//

import UIKit

protocol FlowCoordinatorProtocol {
    func showDetails(for id: Int, title: String)
}

class FlowCoordinator {
    private let navigationController: UINavigationController
    private let networkService: NetworkServiceProtocol

    init(with navigationController: UINavigationController, networkService: NetworkServiceProtocol) {
        self.navigationController = navigationController
        self.networkService = networkService
    }
    
    func start() {
        let listVM = ListViewModel(networkService: networkService, flowCoordinator: self)
        let listVC = ListViewController(with: listVM)
        navigationController.pushViewController(listVC, animated: true)
    }
}

extension FlowCoordinator: FlowCoordinatorProtocol {
    func showDetails(for id: Int, title: String) {
        let detailsVM = DetailsViewModel(with: id, networkService: networkService)
        let detailsVC = DetailsViewController(viewModel: detailsVM)
        detailsVC.title = title
        navigationController.pushViewController(detailsVC, animated: true)
    }
}
