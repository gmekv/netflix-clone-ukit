//
//  UpcomingViewController.swift
//  Netflix Clone Ukit
//
//  Created by Giorgi Mekvabishvili on 02.02.26.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

     override func viewDidLoad() {
        super.viewDidLoad()
         view.backgroundColor = .systemBackground
         title = "Upcoming"
         navigationController?.navigationBar.prefersLargeTitles = true
         navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
         
         view.addSubview(upcomingTable)
         upcomingTable.delegate = self
         upcomingTable.dataSource = self
         fetchUpComing()
             }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpComing() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                DispatchQueue.main.async() {
                    self?.titles = titles
                    self?.upcomingTable.reloadData() }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }}
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row].originalName ?? titles[indexPath.row].originalTitle ?? "N/A"
        return cell
    }
    
    
}
