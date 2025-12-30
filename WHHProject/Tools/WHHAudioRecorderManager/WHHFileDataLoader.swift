//
//  File.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/30.
//

import Foundation

struct WHHFileDataLoader {

    static func load(from url: URL) -> Data? {
        do {
            return try Data(contentsOf: url, options: .mappedIfSafe)
        } catch {
            print("Load data failed:", error)
            return nil
        }
    }
}
