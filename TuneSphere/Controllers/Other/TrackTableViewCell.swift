//
//  TrackTableViewCell.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/6/25.
//

import UIKit
import SDWebImage

class TrackTableViewCell: UITableViewCell {
    
    static let identifier = "TrackTableViewCell"
    
    // MARK: - UI Components
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(albumImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        
        NSLayoutConstraint.activate([
            // Album Image
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            albumImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: 70),
            albumImageView.heightAnchor.constraint(equalToConstant: 70),
            
            // Track Name
            trackNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 16),
            trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            // Artist Name
            artistNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 16),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 4),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configure Cell
    func configure(with track: AudioTrack) {
        trackNameLabel.text = track.name
        artistNameLabel.text = track.artists.first?.name
        
        // Load album artwork
        if let imageUrl = track.album.images.first?.url, let url = URL(string: imageUrl) {
            albumImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            albumImageView.image = UIImage(named: "placeholder")
        }
    }
    
    // MARK: - Prepare for Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
}
