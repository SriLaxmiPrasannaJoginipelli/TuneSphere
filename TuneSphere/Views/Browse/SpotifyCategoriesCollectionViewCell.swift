//
//  SpotifyCategoriesCollectionViewCell.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/5/25.
//

import UIKit

class SpotifyCategoriesCollectionViewCell: UICollectionViewCell {
    static let identifier = "SpotifyCategoriesCollectionViewCell"
    
    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(categoryImageView)
        contentView.addSubview(categoryLabel)
        
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: SpotifyCategoriesCellViewModel) {
        categoryLabel.text = viewModel.name
        if let url = viewModel.artWorkURL {
            downloadImage(from: url)
        }
    }
    
    private func downloadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.categoryImageView.image = image
                }
            }
        }
    }
}

