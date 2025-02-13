//
//  CategoryCell.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/13/25.
//
import UIKit
import SDWebImage // Import SDWebImage

class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.frame = contentView.bounds
        titleLabel.frame = CGRect(x: 10, y: contentView.bounds.height - 30, width: contentView.bounds.width - 20, height: 20)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with category: CategoryItem) {
        titleLabel.text = category.name
        if let imageURLString = category.icons.first?.url, let imageURL = URL(string: imageURLString) {
            // Use SDWebImage to load the image from the URL asynchronously
            imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}
