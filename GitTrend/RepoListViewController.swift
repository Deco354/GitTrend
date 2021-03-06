//
//  RepoListViewController.swift
//  GitTrend
//
//  Created by Declan McKenna on 15/08/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit
import SafariServices

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
        configureRefreshControl()
        gitTrendAPI.fetchTrendingRepos { repos in
            self.repos = repos
            self.reloadTable()
        }
    }
    
    @objc private func handleRefreshControl() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func configureRefreshControl () {
       tableView.refreshControl = UIRefreshControl()
       tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension RepoListViewController: UITableViewDelegate {
    
    /// Launch Embedded Safari browser for Repo at selected Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repoURL = repos[indexPath.row].url
        launchSafari(with: repoURL)
    }
    
    private func launchSafari(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        present(safariViewController, animated: true)
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
        } else {
            downloadImage(at: indexPath)
        }
    }
    
    private func downloadImage(at indexPath: IndexPath) {
        gitTrendAPI.fetchImageData(fromURL: repos[indexPath.row].authorAvatarURL) { data in
            guard let data = data else { return }
            self.repos[indexPath.row].imageData = data
            self.updateImage(forCellAt: indexPath, withImageData: data)
        }
    }
    
    /// Reload row at index path on main thread
    private func updateImage(forCellAt indexPath: IndexPath, withImageData imageData: Data) {
        DispatchQueue.main.async {
            guard let visibleCellToUpdate = self.tableView.cellForRow(at: indexPath) as? RepoCell else {
                return
            }
            visibleCellToUpdate.authorImage.image = UIImage(data: imageData)
        }
    }
}

extension RepoListViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}

extension UITableView {
    
    func isCellVisible(at indexPath: IndexPath) -> Bool {
        let visibleIndices = self.indexPathsForVisibleRows ?? []
        return visibleIndices.contains(indexPath)
    }
}
