//
//  TracksViewController.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/6/25.
//

import UIKit
import AVFoundation

class TracksViewController: UIViewController {
    
    private var audioPlayer: AVPlayer?

    private var tableView: UITableView!
    private var tracks: [AudioTrack]
    

    init(tracks: [AudioTrack]) {
        self.tracks = tracks
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.register(UITableViewCell.self, forCellWithReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
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
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension TracksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = track.name
        cell.detailTextLabel?.text = track.artists.first?.name
        if let previewUrl = track.previewUrl {
                print("Preview URL for \(track.name): \(previewUrl)")
            } else {
                print("No preview URL for \(track.name)")
            }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayback(from: self.navigationController ?? self, track: track)
        if let previewUrlString = track.previewUrl, let previewUrl = URL(string: previewUrlString) {
            playAudio(from: previewUrl)
        } else {
            // Show an alert or message to the user
            showAlert(message: "No preview available for this track.")
        }
    }
}
