//
//  Directory.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-11.
//

import Foundation

class Directory: File {
    @Published public var children: [File]?
    
    func isRoot() -> Bool {
        return parent == nil
    }
}
