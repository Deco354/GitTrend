//
//  StubSession.swift
//  GitTrendTests
//
//  Created by Declan McKenna on 15/08/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation
@testable import GitTrend

/// Stubs URLSession, sends back injected properties and records URL sent to it without making a network request
///
/// This can be used for faster more reliable unit testing of functions that normally make network calls
class StubSession {
    private(set) var interceptedNetworkCallURL: URL?
    private let data: Data?
    private let error: Error?
    /// Can disable completionHandler when we want to simulate a network call that hasn't returned yet
    var willCallCompletionHandler = true
    
    init(data: Data? = nil, error: Error? = nil, willCallCompletionHandler: Bool = true) {
        self.data = data
        self.error = error
    }
    
    /// Creates a StubSession that will return `Data` from a local .json file
    convenience init(jsonResource: String) {
        let testBundle = Bundle(for: Self.self)
        let jsonData = testBundle.jsonData(forResource: jsonResource)
        self.init(data: jsonData, error: nil)
    }
}

extension StubSession: NetworkSession {
    /// Common interface shared by real and stubbed `NetworkSession`s
    func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        interceptedNetworkCallURL = url
        if willCallCompletionHandler {
            completionHandler(data, error)
        }
    }
}

