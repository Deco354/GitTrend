//
//  Repo.swift
//  GitTrend
//
//  Created by Declan McKenna on 15/08/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

struct Repo: Decodable, Equatable {
    let name: String
    let description: String
    let authorName: String
    let url: URL
    let authorAvatarURL: URL
    let starCount: Int
    /// Caches image data
    /// - warning: Will require a properly managed cache if many Repos with image data are loaded. 25 max at present
    var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case name, description, url
        case authorName = "author"
        case authorAvatarURL = "avatar"
        case starCount = "stars"
    }
}

