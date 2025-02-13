//
//  PlayersControlView.swift
//  TuneSphere
//
//  Created by Srilu Rao on 2/12/25.
//

import Foundation
import UIKit

protocol PlayersControlViewDelegate : AnyObject{
    
    func PlayersControlViewDidTapPlayPauseButton(_ playerControlView : PlayersControlView)
    func PlayersControlViewDidTapForwardButton(_ playerControlView : PlayersControlView)
    func PlayersControlViewDidTapBackwardButton(_ playerControlView : PlayersControlView)
    
}

struct playersControlViewViewModel{
    let title : String?
    let subtitle : String?
}

final class PlayersControlView : UIView{
    
    weak var delegate : PlayersControlViewDelegate?
    
    private let volumeSlider : UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel : UILabel = {
        
        let label = UILabel()
        label.text = "This Song"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
        
    }()
    
    private let subtitleLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Oooh Your fav artist"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
        
    }()
    
    private let backButton : UIButton = {
        let backbutton = UIButton()
        backbutton.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        backbutton.setImage(image, for: .normal)
        return backbutton
    }()
    
    private let forwardButton : UIButton = {
        let forwardButton = UIButton()
        forwardButton.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        forwardButton.setImage(image, for: .normal)
        return forwardButton
    }()
    
    private let playPauseButton : UIButton = {
        let playPauseButton = UIButton()
        playPauseButton.tintColor = .label
        let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        playPauseButton.setImage(image, for: .normal)
        return playPauseButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        
        addSubview(backButton)
        addSubview(playPauseButton)
        addSubview(forwardButton)
        
        clipsToBounds = true
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom+10, width: width, height: 44)
        
        let buttonSize : CGFloat = 60
        
        playPauseButton.frame = CGRect(x: (width - buttonSize)/2, y: volumeSlider.bottom + 30, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left-80-buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        forwardButton.frame = CGRect(x: playPauseButton.right+80, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        
        
        
    }
    
    @objc private func didTapBack(){
        
        delegate?.PlayersControlViewDidTapBackwardButton(self)
        
    }
    
    @objc private func didTapPlayPause(){
        delegate?.PlayersControlViewDidTapPlayPauseButton(self)
        
    }
    
    @objc private func didTapForward(){
        delegate?.PlayersControlViewDidTapForwardButton(self)
        
    }
    
    func configure(with viewModel : playersControlViewViewModel){
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}
