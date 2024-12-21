//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 12/19/24.
//

import UIKit

class DetailsViewController: UIViewController {
    private let viewModel: DetailsViewModelProtocol
    private var imageLoadingTask: Task<(), Never>?
    private let imageView = UIImageView()
    private let spinner = UIActivityIndicatorView()
    
    init(viewModel: DetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageLoadingTask?.cancel()
    }
}

private extension DetailsViewController {
    func setupSubviews() {
        view.backgroundColor = .white
        spinner.startAnimating()
        
        [imageView, spinner].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }
    
    func loadData() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                try await viewModel.loadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.loadImage()
                }
            } catch { }
        }
    }
    
    func loadImage() {
        imageLoadingTask = Task { [weak self] in
            guard let self else { return }
            
            do {
                guard let image = try await viewModel.image else { return }

                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    spinner.stopAnimating()
                    imageView.image = UIImage(data: image)
                }
            } catch { }
        }
    }
}
