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
    
    enum CodingKeys: String, CodingKey {
        case name, description, url
        case authorName = "author"
        case authorAvatarURL = "avatar"
        case starCount = "stars"
    }
}

