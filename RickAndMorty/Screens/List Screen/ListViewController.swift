//
//  ListViewController.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 12/19/24.
//

import UIKit

class ListViewController: UITableViewController {
    private let viewModel: ListViewModelProtocol
    
    init(with viewModel: ListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ListCellView.self, forCellReuseIdentifier: String(describing: ListCellView.self))
        
        navigationItem.backButtonDisplayMode = .minimal
        title = "List"
        
        loadData()
    }
}

private extension ListViewController {
    func loadData() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                try await viewModel.loadData()
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            } catch { }
        }
    }
}

extension ListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.list?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListCellView.self)) as? ListCellView else {
            return UITableViewCell()
        }
        cell.resetState()
        cell.viewModel = viewModel.list?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.selectItem(at: indexPath.row)
    }
}
