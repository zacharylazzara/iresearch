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



// TODO: it would probably make more sense to use inheritance instead of the way I'm doing this currently. Should have three classes: file, document, directory. (document and directory inherit from file)
class File: Identifiable, CustomStringConvertible, ObservableObject {//, Comparable {
//    static func == (lhs: File, rhs: File) -> Bool {
//        if lhs.isDir() == rhs.isDir() {
//            return lhs.isDir() == rhs.isDir()
//        } else {
//            return lhs.name == rhs.name
//        }
//    }
//
//    static func < (lhs: File, rhs: File) -> Bool {
//        if lhs.isDir() != rhs.isDir() {
//            return !lhs.isDir()
//        } else {
//            return lhs.name < rhs.name
//        }
//    }
    
    var id: URL { url }
    let url: URL
    let parent: Directory?
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
    
    var description: String {
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
