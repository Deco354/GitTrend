//
//  Bundle+JSONLoader.swift
//  GitTrendTests
//
//  Created by Declan McKenna on 15/08/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

/// Convert a local .json resource in to `Data`.
extension Bundle {
    func jsonData(forResource resourceName: String) -> Data {
        guard let url = self.url(forResource: resourceName, withExtension: "json"),
        let data = try? Data(contentsOf: url)
        else {
            fatalError("\(resourceName).json could not be found")
        }
        return data
    }
}
