//
//  SearchTableViewCell.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/8/25.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {

    // MARK: - UI Components
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()

    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Lifecycle
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

        // Add constraints
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            albumImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: 50),
            albumImageView.heightAnchor.constraint(equalToConstant: 50),

            trackNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 16),
            trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            artistNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 16),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 4),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Configure Cell
    func configure(with track: AudioTrack) {
        trackNameLabel.text = track.name
        artistNameLabel.text = track.artists.first?.name

        // Load album art
        if let imageUrl = track.album.images.first?.url {
            albumImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
        } else {
            albumImageView.image = UIImage(named: "placeholder")
        }
    }
}
