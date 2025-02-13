import UIKit
import AVFoundation

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for songs, artists, albums..."
        return searchBar
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No results found."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: TrackTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Category View
    private var categoryCollectionView: UICollectionView! = nil
    private var categories: [CategoryItem] = []  // Store the categories
    
    // MARK: - Properties
    private var searchResults: [AudioTrack] = [] // Array to store search results
    private var audioPlayer: AVPlayer?
    private var songs: Playlist?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        fetchCategories() // Fetch categories on initial load
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Add search bar
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        // Add table view
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 200, width: view.bounds.width, height: view.bounds.height - 200)
        
        // Add category collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.bounds.width - 20, height: 200) // Adjust the size as needed
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        
        // Set up the collection view with the new layout
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        categoryCollectionView.backgroundColor = .systemBackground
        
        // Add collection view to view
        view.addSubview(categoryCollectionView)
        categoryCollectionView.frame = CGRect(x: 10, y: 120, width: view.bounds.width - 20, height: view.bounds.height - 150)
        
        
        // Empty state label
        emptyStateLabel.frame = CGRect(x: 0, y: view.center.y - 50, width: view.bounds.width, height: 50)
        
        // Add loading indicator
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateLabel)
        loadingIndicator.center = view.center
    }
    
    func playAudio(from url: URL) {
        // Stop any currently playing audio
        audioPlayer?.pause()
        
        // Initialize the audio player with the new URL
        audioPlayer = AVPlayer(url: url)
        
        // Play the audio
        audioPlayer?.play()
        
        // Optional: Add observer for playback completion
        NotificationCenter.default.addObserver(self, selector: #selector(audioDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: audioPlayer?.currentItem)
    }
    
    @objc private func audioDidFinishPlaying() {
        print("Audio finished playing.")
    }
    
    // MARK: - Fetch Categories
    private func fetchCategories() {
        loadingIndicator.startAnimating()
        
        APICaller.shared.getBrowseCategories { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                switch result {
                case .success(let response):
                    self?.categories = response.categories.items
                    self?.categoryCollectionView.reloadData()
                case .failure(let error):
                    print("Error fetching categories: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchBar.resignFirstResponder() // Dismiss the keyboard
        
        // Show loading indicator
        loadingIndicator.startAnimating()
        
        // Call the API to fetch search results
        APICaller.shared.searchResult(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                switch result {
                case .success(let response):
                    // Update the searchResults array with the fetched data
                    self?.searchResults = response.tracks.items
                    self?.tableView.reloadData()
                    self?.emptyStateLabel.isHidden = !self!.searchResults.isEmpty
                    
                    // Hide categories when search is in progress
                    self?.categoryCollectionView.isHidden = true
                case .failure(let error):
                    print("Failed to fetch search results: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Table View DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.identifier, for: indexPath) as? TrackTableViewCell else {
            return UITableViewCell()
        }
        let track = searchResults[indexPath.row]
        cell.configure(with: track)
        return cell
    }
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let track = searchResults[indexPath.row]
        
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
        // Check if the track has a preview URL
        if let previewUrlString = track.previewUrl, let previewUrl = URL(string: previewUrlString) {
            playAudio(from: previewUrl)
        } else {
            print("No preview available for this track.")
        }
    }
    
    // MARK: - Collection View DataSource (Categories)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]
        cell.configure(with: category)
        return cell
    }
    
    // MARK: - Collection View Delegate (Categories)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        navigateToPlaylistViewController(for: selectedCategory)
    }
    
    // MARK: - Navigate to Playlist View
    private func navigateToPlaylistViewController(for category: CategoryItem) {
        // Fetch playlists for the selected category
        APICaller.shared.categoryPlaylists(categoryName: category.name) { [weak self] result in
            switch result {
            case .success(let playlists):
                DispatchQueue.main.async {
                    let playlistVC = PlaylistViewController()
                    let songs = playlists.playlists.items.compactMap { $0 }
                    playlistVC.configure(with: songs)
                    self?.navigationController?.pushViewController(playlistVC, animated: true)
                }
            case .failure(let error):
                print("Failed to fetch playlists: \(error.localizedDescription)")
            }
        }
    }
}
