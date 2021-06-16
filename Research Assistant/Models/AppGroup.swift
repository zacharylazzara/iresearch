//
//  AppGroup.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-09.
//

import Foundation

public enum AppGroup: String {
    case root = "group.dev.lazzara.Research-Assistant"
    case library = "Library"
    case documents = "Papers"
    
    public var containerURL: URL {
        switch self {
        case .root:
            return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)!
        case .library:
            return AppGroup.root.containerURL.appendingPathComponent(self.rawValue, isDirectory: true)
        case .documents:
            let fileManager = FileManager.default
            let documents = AppGroup.library.containerURL.appendingPathComponent(self.rawValue, isDirectory: true)
            
            if !fileManager.fileExists(atPath: documents.path) {
                do {
                    print("\(documents.lastPathComponent) doesn't exist! Creating directory...")
                    try fileManager.createDirectory(at: documents, withIntermediateDirectories: true, attributes: nil)
                    print("Successfully created \(documents.lastPathComponent)!")
                } catch {
                    print(error)
                }
            }
            
            return documents
        }
    }
}
