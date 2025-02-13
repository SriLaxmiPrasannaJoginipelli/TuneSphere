//
//  PLayerViewController.swift
//  TuneSphere
//
//  Created by Srilu Rao on 1/29/25.
//
import UIKit
import SDWebImage


class PlayerViewController: UIViewController {
    
    weak var dataSource : PlayerDataSource?
    
    private let imageView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        return imageView
        
    }()
    
    private let controlsView = PlayersControlView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        configureBarButtonItems()
        controlsView.delegate = self
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom + 10,
            width: view.width - 20,
            height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15)
    }
    
    private func configureBarButtonItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    private func configure(){
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        controlsView.configure(with: playersControlViewViewModel(title: dataSource?.songName, subtitle: dataSource?.subtitle))
        
    }
}

extension PlayerViewController : PlayersControlViewDelegate{
    func PlayersControlViewDidTapPlayPauseButton(_ playerControlView: PlayersControlView) {
        
    }
    
    func PlayersControlViewDidTapForwardButton(_ playerControlView: PlayersControlView) {
        
    }
    
    func PlayersControlViewDidTapBackwardButton(_ playerControlView: PlayersControlView) {
        
    }
    
    
}

