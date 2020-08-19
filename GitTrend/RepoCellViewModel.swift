//
//  RepoCellViewModel.swift
//  GitTrend
//
//  Created by Declan McKenna on 19/08/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

class RepoCellViewModel {
    private var repo: Repo
    private let imageLoader: GitTrendAPI
    
    init(repo: Repo, imageLoader: GitTrendAPI) {
        self.repo = repo
        self.imageLoader = imageLoader
    }
    
    var title: String {
        repo.name
    }
    
    var description: String {
        repo.description
    }
    
    var author: String {
        repo.authorName
    }
    
    var starCountText: String {
        String(repo.starCount)
    }
    
    var imageData: Data? {
        if repo.imageData == nil  {
            imageLoader.fetchImageData(fromURL: repo.url) { data in
                guard let data = data else { return }
                self.repo.imageData = data
            }
        }
        return repo.imageData
    }
}
