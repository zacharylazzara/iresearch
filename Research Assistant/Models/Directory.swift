//
//  Directory.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-11.
//

import Foundation

class Directory: File, ObservableObject {
    static func == (lhs: Directory, rhs: Directory) -> Bool {
        return lhs.name == rhs.name
    }

    static func < (lhs: Directory, rhs: Directory) -> Bool {
        return lhs.name < rhs.name
    }
    
    @Published public var children: [File]?
    
    func isRoot() -> Bool {
        return parent == nil
    }
}
