//
//  RepoListViewController.swift
//  GitTrend
//
//  Created by Declan McKenna on 15/08/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit

/// Displays list of trending repos within `UITableView`
class RepoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let gitTrendAPI: GitTrendAPI
    var repos: [Repo] = []
    
    init?(coder: NSCoder, api: GitTrendAPI) {
        self.gitTrendAPI = api
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lowerNavigationBarText()
        gitTrendAPI.fetchTrendingRepos { repos in
            self.repos = repos
            self.reloadTable()
        }
    }
    
    /// Adjusts Navigation Bar Text so it's not too close to the status bar for phones without top-notch (iphone SE & 8)
    private func lowerNavigationBarText() {
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(CGFloat(5), for: UIBarMetrics.default)
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension RepoListViewController: UITableViewDelegate {}

extension RepoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as? RepoCell else {
            fatalError("TableView cast to invalid or non existant type")
        }
        configure(cell: cell, at: indexPath)
        return cell
    }
    
    private func configure(cell: RepoCell, at indexPath: IndexPath) {
        let repo = repos[indexPath.row]
        cell.nameLabel.text = repo.name
        cell.authorLabel.text = repo.author
        cell.descriptionLabel.text = repo.description
        cell.starCountLabel.text = String(repo.stars)
    }
}

