//
//  Document.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-07.
//

import Foundation
import QuickLook

class File: NSObject, Identifiable, Comparable {
    static func == (lhs: File, rhs: File) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: File, rhs: File) -> Bool {
        return lhs.name < rhs.name
    }
    
    var id: URL { url }
    var url: URL
    var parent: Directory?
    var name: String
    
    let added: Date?
    var accessed: Date? // When the user last read the file
    var tags: [String]
    var flagged: Bool
    var archived: Bool
    
    init(url: URL, name: String, parent: Directory? = nil) {
        self.url = url
        self.name = name
        self.parent = parent
        
        // TODO: figure out what to do with these later
        self.added = nil
        self.accessed = nil
        self.tags = []
        self.flagged = false
        self.archived = false
    }
    
    override var description: String {
        switch parent {
        case nil:
            return "ROOT: \(name)"
        case .some(let parent):
            return "Parent: \(parent.name) File: \(name)"
        }
    }
    
    func isHidden() -> Bool {
        return (try? url.resourceValues(forKeys: [.isHiddenKey]).isHidden)!
    }
}

extension File: QLPreviewItem {
    var previewItemURL: URL? {
        url
    }
    
    var previewItemTitle: String? {
        name
    }
}
