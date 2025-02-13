import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // Cover Image
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            coverImageView.widthAnchor.constraint(equalToConstant: 80),
            
            // Album Name
            albumNameLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            albumNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            albumNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // Artist Name
            artistNameLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 5),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // Number of Tracks
            numberOfTracksLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            numberOfTracksLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 5),
            numberOfTracksLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            numberOfTracksLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        coverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        coverImageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
    }
}
