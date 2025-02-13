//
//  PlaybackPresenter.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/12/25.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource : AnyObject{
    var songName : String?{get}
    var subtitle : String?{get}
    var imageURL : URL?{get}
}

final class PlaybackPresenter{
    
    private var track : AudioTrack?
    private var tracks = [AudioTrack]()
    
    private var player : AVPlayer?
    
    var currentTrack : AudioTrack?{
        if let track = track, tracks.isEmpty{
            return track
        }else if !tracks.isEmpty{
            return tracks.first
        }
        return nil
    }
    
    
    static let shared = PlaybackPresenter()
    
//     func startPlayback(from viewController : UIViewController, track : AudioTrack){
//         
//         guard let url = URL(string: track.previewUrl ?? "") else{
//             print("oops no preview!!!")
//             return
//         }
//         player = AVPlayer(url: url)
//         player?.volume = 0.5
//         self.track = track
//         self.tracks = []
//        let vc = PlayerViewController()
//        vc.title = track.name
//         vc.dataSource = self
//         viewController.present(UINavigationController(rootViewController: vc), animated: true) {[weak self] in
//             self?.player?.play()
//         }
//    }
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        self.track = track
        self.tracks = []
        
        // Present PlayerViewController
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            guard let self = self else { return }
            
            // Now check for preview URL
            guard let urlString = track.previewUrl, let url = URL(string: urlString) else {
                // No preview URL → Show an alert but **do not dismiss the player**
                self.showAlert(on: vc, message: "Oops! No preview available for this track.")
                return
            }
            
            // If valid URL, play the audio
            self.player = AVPlayer(url: url)
            self.player?.volume = 0.5
            self.player?.play()
        }
    }

    
     func startPlayback(from viewController : UIViewController, tracks : [AudioTrack]){
        
    }
    
    private func showAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Playback Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}

extension PlaybackPresenter : PlayerDataSource{
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album.images.first?.url ?? "No image URl")
    }
    
    
}
