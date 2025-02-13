//
//  ProfileViewController.swift
//  TuneSphere
//
//  Created by Srilu Rao on 1/29/25.
//


import UIKit
import SDWebImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    private var models = [String]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 4
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchProfile()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        logoutButton.frame = CGRect(x: 20, y: view.height - 90, width: view.width - 40, height: 50)
    }

    // MARK: - Setup UI
    private func setupUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        //view.addSubview(logoutButton)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }

    // MARK: - Fetch Profile
    private func fetchProfile() {
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure:
                    self?.failedToGetProfile()
                }
            }
        }
    }

    // MARK: - Update UI
    private func updateUI(with model: UserProfile) {
        tableView.isHidden = false
        models = [
            "👤 Name: \(model.display_name)",
            "🌍 Country: \(model.country)",
            "🆔 ID: \(model.id)"
        ]
        createTableHeader(with: model.images.first?.url)
        tableView.reloadData()
    }
    
    private func failedToGetProfile() {
            let label = UILabel(frame: .zero)
            label.text = "Failed to load your profile."
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            label.textColor = .secondaryLabel
            label.sizeToFit()
            label.center = view.center
            view.addSubview(label)
        }

    // MARK: - Create Table Header
   private func createTableHeader(with url: String?) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width / 1.8))
        headerView.backgroundColor = .clear

        let imageSize = headerView.height / 2.5
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        imageView.center = CGPoint(x: headerView.center.x, y: headerView.center.y + 20)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageSize / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor

        // If the URL is available, load the image; otherwise, set a default avatar
        if let urlString = url, let imageURL = URL(string: urlString) {
            imageView.sd_setImage(with: imageURL, completed: nil)
        } else {
            // Default avatar - use SF Symbol or local image
            let defaultAvatar = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            imageView.image = defaultAvatar
        }

        headerView.addSubview(imageView)
        tableView.tableHeaderView = headerView
    }


    // MARK: - Logout Action
    @objc private func didTapLogout() {
        print("User logged out")
    }

    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { models.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
}



