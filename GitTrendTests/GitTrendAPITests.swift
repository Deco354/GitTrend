//
//  GitTrendAPITests.swift
//  GitTrendTests
//
//  Created by Declan McKenna on 15/08/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import XCTest
@testable import GitTrend

class GitTrendAPITests: XCTestCase {
    var expectedURL = URL(string: "https://ghapi.huchen.dev/repositories?language=swift&since=weekly&spoken_language_code=en")!
    var returnedRepos: [Repo] = []
    var testBundle: Bundle { Bundle(for: Self.self) }

    func testDownloadModels() throws {
        let expectedRepos = try JSONDecoder().decode([Repo].self, from: Bundle(for: Self.self).jsonData(forResource: "GithubResponse"))
        
        let stubSession = StubSession(jsonResource: "GithubResponse")
        let request = GitTrendAPI(session: stubSession)
        request.fetchTrendingRepos { repos in
            self.returnedRepos = repos
        }
        XCTAssertEqual(stubSession.interceptedNetworkCallURL, expectedURL)
        XCTAssertEqual(returnedRepos, expectedRepos)
    }
    
    func testErrorRequest() throws {
        let stubSession = StubSession(error: NSError(domain: "", code: 0))
        let request = GitTrendAPI(session: stubSession)
        request.fetchTrendingRepos { repos in
            self.returnedRepos = repos
        }
        XCTAssert(returnedRepos.isEmpty)
        XCTAssertNotNil(stubSession.interceptedNetworkCallURL)
    }
    
    func testDatalessRequest() throws {
        let stubSession = StubSession(data: nil)
        let request = GitTrendAPI(session: stubSession)
        request.fetchTrendingRepos { repos in
            self.returnedRepos = repos
        }
        XCTAssert(returnedRepos.isEmpty)
        XCTAssertNotNil(stubSession.interceptedNetworkCallURL)
    }
}
