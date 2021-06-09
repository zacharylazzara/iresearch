//
//  AppGroup.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-09.
//

import Foundation

public enum AppGroup: String {
    case library = "group.dev.lazzara.Research-Assistant"
    
    public var containerURL: URL {
        switch self {
        case .library:
            return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)!
        }
    }
}
