//
//  ListCellView.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 12/20/24.
//

import UIKit

class ListCellView: UITableViewCell {
    var viewModel: ListCellViewModelProtocol? {
        didSet {
            configureSubviews()
        }
    }
    
    private let label = UILabel()
    private let thumbnail = UIImageView()
    private let spinner = UIActivityIndicatorView()
    
    private var imageLoadingTask: Task<(), Never>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadingTask?.cancel()
    }
    
    func resetState() {
        label.text = nil
        thumbnail.image = nil
        spinner.startAnimating()
    }
}

private extension ListCellView {
    func setupSubviews() {
        spinner.startAnimating()
        
        [label, thumbnail, spinner].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: thumbnail.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            thumbnail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            thumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            thumbnail.heightAnchor.constraint(equalToConstant: 100),
            thumbnail.widthAnchor.constraint(equalToConstant: 100),
            
            spinner.centerYAnchor.constraint(equalTo: thumbnail.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: thumbnail.centerXAnchor)
        ])
    }
    
    func configureSubviews() {
        label.text = viewModel?.name
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadImage()
        }
    }
    
    func loadImage() {
        imageLoadingTask = Task { [weak self] in
            guard let self, let viewModel else { return }
            
            do {
                let image = try await viewModel.image

                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    spinner.stopAnimating()
                    thumbnail.image = UIImage(data: image)
                }
            } catch { }
        }
    }
}
