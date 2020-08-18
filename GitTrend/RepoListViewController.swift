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
    
    /// Reload row at index path on main thread
    private func reloadRow(atIndexPath indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension RepoListViewController: UITableViewDelegate {
    /// Downloads author avatar image if it's not cached locally
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if repos[indexPath.row].imageData == nil {
            downloadImage(at: indexPath)
        }
    }
    
    private func downloadImage(at indexPath: IndexPath) {
        gitTrendAPI.fetchImageData(fromURL: repos[indexPath.row].authorAvatarURL) { data in
            self.repos[indexPath.row].imageData = data
            self.reloadRow(atIndexPath: indexPath)
        }
    }
}

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
        cell.authorLabel.text = repo.authorName
        cell.descriptionLabel.text = repo.description
        cell.starCountLabel.text = String(repo.starCount)
        if let imageData = repo.imageData {
            cell.authorImage.image = UIImage(data: imageData)
        }
    }
}
