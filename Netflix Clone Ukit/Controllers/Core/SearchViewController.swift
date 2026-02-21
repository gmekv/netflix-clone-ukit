//
//  SearchViewController.swift
//  Netflix Clone Ukit
//
//  Created by Giorgi Mekvabishvili on 02.02.26.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles: [Title] = [Title]()

    
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
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoverMovies()
        
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self ] result in
            switch result {
            case .success(let titles):
                self?.titles =  titles
                DispatchQueue.main.async {
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else  {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

//extension SearchViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        guard let query = searchBar.text,
//              !query.trimmingCharacters(in: .whitespaces).isEmpty,
//              query.trimmingCharacters(in: .whitespaces).count >= 3 else {
//            let resultsController = searchController.searchResultsController as? SearchResultsView
//        }
//    }
//    
//    
//}
