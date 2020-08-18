//
//  GitTrendAPI.swift
//  GitTrend
//
//  Created by Declan McKenna on 15/08/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation
import UIKit.UIImage

/// Downloads trending repos from [github-trending-api](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/Links.html)
class GitTrendAPI  {
    private let session: NetworkSession
    private let url = URL(string: "https://ghapi.huchen.dev/repositories?language=swift&since=weekly&spoken_language_code=en")!
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    /// Downloads json from github-trending-api and decodes in to `Repo` array
    func fetchTrendingRepos(withCompletion completionHandler: @escaping ([Repo]) -> Void) {
        session.loadData(from: self.url) { json,error in
            guard let json = json,
                error == nil else {
                    completionHandler([])
                    print(error ?? "No Data or error found")
                    return
            }
            let repos = self.decode(json: json)
            completionHandler(repos)
        }
    }
    
    /// Downloads image data from network resource via URL.
    /// - note: Returns Data rather than `UIImage` to save memory
    /// - todo: Track active requests so more than one request can't be made to the same image
    func fetchImageData(fromURL url: URL, withCompletion completionHandler: @escaping (Data?) -> Void) {
        session.loadData(from: url) { data,error in
            guard let data = data,
                error == nil else {
                    completionHandler(nil)
                    print(error ?? "No Data or error found")
                    return
            }
            completionHandler(data)
        }
    }
    
    private func decode(json: Data) -> [Repo] {
        let decoder = JSONDecoder()
        do {
            let rawResponse = try decoder.decode([Repo].self, from: json)
            return rawResponse
        } catch(let error) {
            print(error)
            return []
        }
    }
}

