//
//  RepoTests.swift
//  GitTrendTests
//
//  Created by Declan McKenna on 15/08/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import XCTest
@testable import GitTrend

class RepoTests: XCTestCase {
    let decoder = JSONDecoder()
    var testBundle: Bundle { Bundle(for: Self.self) }
    
    func testJSONDecoding() {
        let expectedRepos = [Repo(name: "gvisor", author: "google", url: URL(string: "https://github.com/google/gvisor")!, avatar: URL(string: "https://github.com/google.png")!, stars: 3320)]
        
        let validJSON = testBundle.jsonData(forResource: "GithubResponse")
        do {
            let decodedRepos = try decoder.decode([Repo].self, from: validJSON)
            XCTAssertEqual(decodedRepos, expectedRepos)
        } catch(let error) {
            XCTFail("JSON Parsing failed with error: \(error)")
        }
    }
    
}
