import UIKit
import AVFoundation

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

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

    // MARK: - Properties
    private var searchResults: [AudioTrack] = [] // Array to store search results
    private var audioPlayer: AVPlayer?
    private var songs :Playlist?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       // emptyStateLabel.isHidden = false
        setupUI()
        //loadInitialData()
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
        tableView.frame = view.bounds
        
        emptyStateLabel.frame = CGRect(x: 0, y: view.center.y - 50, width: view.bounds.width, height: 50)

        // Add loading indicator
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateLabel)
        loadingIndicator.center = view.center
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
                    self?.emptyStateLabel.isHidden = true// Reload the table view
                case .failure(let error):
                    print("Failed to fetch search results: \(error.localizedDescription)")
                }
            }
        }
        
        if searchResults.isEmpty {
            emptyStateLabel.isHidden = false
        } else {
            emptyStateLabel.isHidden = true
        }
    }
    
    // MARK: - To deal with Audio
    private func playPreview(url: URL) {
        // Stop any existing playback
        audioPlayer?.pause()
        audioPlayer = nil

        // Create a new AVPlayer instance
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
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
            playPreview(url: previewUrl)
        } else {
            print("No preview available for this track.")
        }
    }
}
