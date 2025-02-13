//
//  WelcomeViewController.swift
//  TuneSphere
//
//  Created by Srilu Rao on 1/29/25.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let button : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("SignIn", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGreen
        title = "Welcome"
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(x: 20, y: view.height-50-view.safeAreaInsets.bottom, width: view.width-40, height: 50)
    }
    
    @objc func didTapSignIn(){
        let vc = AuthViewController()
        vc.completionHandler = {[weak self]sucess in
            
            DispatchQueue.main.async {
                self?.handleSignIn(sucess: sucess)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(sucess: Bool){
        
        guard sucess else{
            let alert = UIAlertController(title: "Try Again!", message: "Failed while loggig in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let tabBarController = TabBarViewController()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
        
    }
    
}
