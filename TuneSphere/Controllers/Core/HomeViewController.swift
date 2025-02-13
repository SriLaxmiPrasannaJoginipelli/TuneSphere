//
//  ViewController.swift
//  TuneSphere
//
//  Created by Srilu Rao on 1/29/25.
//

import UIKit

enum BrowseSectionType{
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case spotifyCategories(viewModels: [SpotifyCategoriesCellViewModel])
}

class HomeViewController: UIViewController {
    
    private var collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout {
        sectionIndex, _ in
        return createSectionLayout(index: sectionIndex)
    }
                                                                     
    )
    
    private var sections = [BrowseSectionType]()
    //Ananymous Closure
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(SpotifyCategoriesCollectionViewCell.self, forCellWithReuseIdentifier: SpotifyCategoriesCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        //collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
    private static func createSectionLayout(index : Int)-> NSCollectionLayoutSection {
        
        switch index{
        case 0:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                subitem: item,
                count:3
            )
            
            let horizantalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)),
                subitem: verticalGroup,
                count:1
            )
            let section = NSCollectionLayoutSection(group: horizantalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        
        case 1:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(250),
                    heightDimension: .absolute(250)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let horizantalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(250),
                    heightDimension: .absolute(250)),
                subitem: item,
                count:1
            )
            let section = NSCollectionLayoutSection(group: horizantalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
            
            
        default:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                subitem: item,
                count:1
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        
        
    }
    
    private func fetchData(){
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        
        var newRelease : NewReleasesResponse?
        var categories : SpotifyCategoriesResponse?
        APICaller.shared.getNewReleases() { response in
            defer{
                group.leave()
            }
            switch response{
            case .success(let model):
                newRelease = model
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            
        }
        
        APICaller.shared.getBrowseCategories() { response in
            defer{
                group.leave()
            }
            switch response{
            case .success(let model):
                categories = model
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            
        }
        
        group.notify(queue: .main){
            
            guard let newAlbum = newRelease?.albums.items, let categories = categories?.categories.items else{
                return
            }
            self.configureModels(newAlbums: newAlbum, cotegories: categories)
            
        }
        
    }
    
    private func configureModels(newAlbums:[Albums],cotegories:[CategoryItem]){
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name, artWorkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "")
        })))
        sections.append(.spotifyCategories(viewModels: cotegories.compactMap {
                return SpotifyCategoriesCellViewModel(
                    name: $0.name,
                    artWorkURL: URL(string: $0.icons.first?.url ?? ""), id: $0.id
                )
            }))
        
        collectionView.reloadData()
        
    }
    
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type{
        case .newReleases(let viewModels):
            return viewModels.count
        case .spotifyCategories(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        switch type{
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else{
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .spotifyCategories(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpotifyCategoriesCollectionViewCell.identifier, for: indexPath) as? SpotifyCategoriesCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let section = sections[indexPath.section]
            
            switch section {
            case .spotifyCategories(let viewModels):
                let selectedCategory = viewModels[indexPath.row]
                APICaller.shared.categoryPlaylists(categoryName: selectedCategory.name) { [weak self] result in
                    switch result {
                    case .success(let categoryDetails):
                        
                        let songs = categoryDetails.playlists.items.compactMap { $0 }
                        
                        DispatchQueue.main.async{
                            let vc = PlaylistViewController()
                            vc.configure(with: songs)
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    case .failure(let error):
                        print("Failed to get category details:", error.localizedDescription)
                    }
                }
            default:
                break
            }
        }
    
    
}

