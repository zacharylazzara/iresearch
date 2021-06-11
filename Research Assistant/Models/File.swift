//
//  Document.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-07.
//

import Foundation


/* TODO: we should implement File in such a way we can iterate recursively. This will make things significantly easier and more efficient. For now however I'll leave it as is, just to get things figured out and working. After I've gotten everything barely working, I'll start refining and polishing things (including implementing resursion where possible, such as with file navigation).
 
 
 
 
 
 
 
 
 struct File: Hashable, Identifiable, CustomStringConvertible {
     var id: Self { self } // The ID will double as the URL to the document
     var name: String
     var children: [File]?
     var description: String {
         switch children {
         case nil:
             return "📄 \(name)"
         case .some(let children):
             return children.isEmpty ? "📂 \(name)" : "📁 \(name)"
         }
     }
     
     init(name: String, children: [File]? = nil) {
         self.name = name
         self.children = children
     }
     
     
 */




class File: Identifiable, Comparable, CustomStringConvertible {
    static func == (lhs: File, rhs: File) -> Bool {
        if lhs.isDir() == rhs.isDir() {
            return lhs.isDir() == rhs.isDir()
        } else {
            return lhs.name == rhs.name
        }
    }
    
    static func < (lhs: File, rhs: File) -> Bool {
        if lhs.isDir() != rhs.isDir() {
            return !lhs.isDir()
        } else {
            return lhs.name < rhs.name
        }
    }
    
    var id: Self { self } // The ID will double as the URL to the document
    let url: URL
    
    // TODO: need to support moving documents to new directories
    let parent: File?
    var children: [File]?
    
    
    
    var remote: Bool // If the file is remote then we allow users to edit the title; if the file is local then edititng the title will edit the file on disk.
    var name: String // Will be the .lastPathComponent of the URL by default, but we may want to allow users to edit this to make documents easier to identify.
    
    let added: Date?
    var accessed: Date? // When the user last read the file
    
    var tags: [String]
    var flagged: Bool
    
    var archived: Bool
    
    init(url: URL, name: String, parent: File? = nil, children: [File]? = nil) {
        self.url = url
        self.name = name
        self.parent = parent
        self.children = children
        
        // TODO: figure out what to do with these later
        self.added = nil
        self.accessed = nil
        self.tags = []
        self.flagged = false
        self.remote = false
        self.archived = false
    }
    
    var description: String {
        switch parent {
        case nil:
            return "ROOT: \(name)"
        case .some(let parent):
            return "Parent: \(parent.name) File: \(name)"
        }
    }
    
    func isRoot() -> Bool {
        return parent == nil
    }
    
    func isDir() -> Bool {
        return (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory)!
    }
    
    func isHidden() -> Bool {
        return (try? url.resourceValues(forKeys: [.isHiddenKey]).isHidden)!
    }
}
