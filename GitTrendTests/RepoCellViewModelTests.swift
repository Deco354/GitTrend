//
//  RepoCellViewModelTests.swift
//  GitTrendTests
//
//  Created by Declan McKenna on 19/08/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import XCTest
@testable import GitTrend

class RepoCellViewModelTests: XCTestCase {
    
    let testRepo = Repo(name: "GitTrend",
                           description: "Displays trending Git Repos",
                           authorName: "Declan McKenna",
                           url: URL(string: "www.omg.com")!,
                           authorAvatarURL: URL(string: "www.img.com")!,
                           starCount: 42,
                           imageData: nil)
    
    func testInitWithModelMapsProperties() {
        let stubSession = StubSession(willCallCompletionHandler: false)
        let stubImageLoader = GitTrendAPI(session: stubSession)
       
        
        let viewModel = RepoCellViewModel(repo: testRepo, imageLoader: stubImageLoader)
        XCTAssertEqual(viewModel.title, testRepo.name)
        XCTAssertEqual(viewModel.description, testRepo.description)
        XCTAssertEqual(viewModel.author, testRepo.authorName)
        XCTAssertEqual(viewModel.starCountText, "42")
        XCTAssertNil(viewModel.imageData)
    }
    
    func testSuccessfulImageDataLoading() {
        let expectedData = Data([0,0,1,1])
        
        let stubSession = StubSession(data:expectedData)
        let stubImageLoader = GitTrendAPI(session: stubSession)
        
        let viewModel = RepoCellViewModel(repo: testRepo, imageLoader: stubImageLoader)
        XCTAssertEqual(viewModel.imageData, expectedData)
    }
    
    func testFailedImageDataLoading() {
        let stubSession = StubSession(data: nil)
        let stubImageLoader = GitTrendAPI(session: stubSession)
        
        let viewModel = RepoCellViewModel(repo: testRepo, imageLoader: stubImageLoader)
        XCTAssertNil(viewModel.imageData)
    }
    
    func testFailedImageLoadDoesNotOverrideExistingImage() {
        let expectedData = Data([0,0,1,1])
        
        let stubSession = StubSession(data: nil)
        let stubImageLoader = GitTrendAPI(session: stubSession)
        var repo = testRepo
        repo.imageData = expectedData
        
        let viewModel = RepoCellViewModel(repo: repo, imageLoader: stubImageLoader)
        XCTAssertEqual(viewModel.imageData, expectedData)
    }
}
