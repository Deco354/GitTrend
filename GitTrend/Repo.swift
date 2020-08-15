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
    let author: String
    let url: URL
    let avatar: URL
    let stars: Int
}

