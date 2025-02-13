//
//  PlaylistViewController.swift
//  TuneSphere
//
//  Created by Srilu Rao on 1/29/25.
//


import UIKit
import AVFoundation

class PlaylistViewController: UIViewController {
    
    private var tableView: UITableView!
    private var songs: [Playlist]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        if let playlists = songs {
            configure(with: playlists)
        }
    }
    
    private func setupUI() {
        title = "Playlists"
        view.backgroundColor = .systemBackground
        
        // Customize Navigation Bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: PlaylistTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        view.addSubview(tableView)
        
        // Add Pull-to-Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        // Simulate a network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func configure(with songs: [Playlist]) {
        self.songs = songs
        tableView?.reloadData()
    }
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.identifier, for: indexPath) as? PlaylistTableViewCell else {
            return UITableViewCell()
        }
        
        if let playlist = songs?[indexPath.row] {
            cell.configure(with: playlist)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle playlist selection
        guard let playlist = songs?[indexPath.row] else { return }

            // Fetch tracks for the selected playlist
        guard let playlist = songs?[indexPath.row] else { return }
        
        // Fetch tracks for the selected playlist
        APICaller.shared.fetchTracks(for: playlist) { [weak self] result in
            switch result {
            case .success(let tracks):
                DispatchQueue.main.async{
                    let tracksVC = TracksViewController(tracks: tracks)
                    self?.navigationController?.pushViewController(tracksVC, animated: true)
                }
            case .failure(let error):
                print("Failed to fetch tracks: \(error.localizedDescription)")
            }
        }
    }
}




