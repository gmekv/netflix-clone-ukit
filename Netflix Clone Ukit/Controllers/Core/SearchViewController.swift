//
//  SearchViewController.swift
//  Netflix Clone Ukit
//
//  Created by Giorgi Mekvabishvili on 02.02.26.
//

import UIKit



class SearchViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or a TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always

        view.backgroundColor = .systemBackground
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoverMovies()
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self ] result in
            switch result {
            case .success(let titles):
                DispatchQueue.main.async {
                    self?.titles =  titles
                    self?.discoverTable.reloadData()
                }
        
            
            case .failure(let error):
                print(error)
            }
            }
            }


     override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else  {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(
            titleName: (title.originalTitle ?? title.originalName) ?? "Unknown title",
            posterURL: title.posterPath ?? ""
        ))

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName = (title.originalTitle ?? title.originalName) ?? ""
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(
                        title: titleName,
                        youtubeView: videoElement,
                        titleOverView: title.overview
                    ))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ viewMOdel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewMOdel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
     
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        resultsController.delegate  = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }}
