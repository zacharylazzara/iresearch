//
//  ContentViewModel.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-08.
//

import Foundation

/* TODO:
 - Load PDFs from local storage
 - Load PDFs from web (HTTPS; may need to give an option to allow HTTP as well)
 - Need to make sure we're doing file navigation properly; want to avoid duplicating things in memory
 */

class DirectoryViewModel: ObservableObject {
    private let fm: FileManager
    private let documents: URL
    
    @Published public var directory: Directory
    @Published public var showHidden: Bool
    
    init() {
        self.fm = FileManager.default
        self.documents = AppGroup.documents.containerURL //AppGroup.library.containerURL.appendingPathComponent("Library", isDirectory: true).appendingPathComponent("Papers", isDirectory: true)
        self.showHidden = false
        
        print("Root URL: \(self.documents)")
        
//        if !self.fm.fileExists(atPath: self.rootURL.path) {
//            do {
//                print("\(self.rootURL.lastPathComponent) doesn't exist! Creating directory...")
//                try self.fm.createDirectory(at: self.rootURL, withIntermediateDirectories: true, attributes: nil)
//                print("Successfully created \(self.rootURL.lastPathComponent)!")
//            } catch {
//                print(error)
//            }
//        }
        
        self.directory = Directory(url: self.documents, name: self.documents.lastPathComponent)
        self.directory.children = load(dir: self.directory)
    }
    
    // TODO: we can use .DS_Store to store our custom attributes such as which files are flagged etc
    // TODO: look into  https://developer.apple.com/documentation/appkit/nsoutlineview
    // TODO: Also look into outline groups (this is what we'd use for iOS I think) https://developer.apple.com/documentation/swiftui/outlinegroup
    // TODO: we need to auto-update the view when the directory's children change (currently view only updates when the directory changes, but not when it gets new folders)
    
    // TODO: a view stabalization feature may be useful so people can read while walking? we want to target this at people who are mobile, so things have to be quick, easy, and intuitive
    
    public func changeDir(dir: Directory) { // TODO: maybe check to make sure we don't try to change to a data file vs a directory?
        self.directory = dir
    }
    
    public func loadData(doc: Document) -> Data {
        return try! doc.read()
    }
    
    public func loadDir() -> [File] {
        return self.directory.children!
    }
    
    private func load(dir: Directory) -> [File]? {
        print("Loading from directory: \(dir.name)")
        
        var children = [File]()
        let fileChildren: [URL]
        
        do {
            fileChildren = try fm.contentsOfDirectory(at: dir.url, includingPropertiesForKeys: nil) // TODO: look into includingPropertiesForKeys, maybe we can get dates and such with it?
        } catch {
            print(error)
            return nil
        }
        
        print("Found: \(fileChildren)")
        
        for url in fileChildren {
            let child: File
            
            if (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory)! {
                child = Directory(url: url, name: url.lastPathComponent, parent: dir)
                (child as! Directory).children = load(dir: child as! Directory)
            } else {
                child = Document(url: url, name: url.lastPathComponent, parent: dir)
            }
            
            children.append(child)
            children.sort(by: >)
        }
        
        return children
    }
    
    public func createDir(name: String = "New Folder") {
        var uName = name
        var collisions = 0
        
        while self.directory.children!.contains(where: {file in file.name == uName}) {
            uName = name
            collisions += 1
            uName = "\(uName)(\(collisions))"
        }
        
        do {
            let newDir = Directory(url: self.directory.url.appendingPathComponent(uName), name: uName, parent: self.directory)
            try fm.createDirectory(at: newDir.url, withIntermediateDirectories: false, attributes: nil)
            newDir.children = load(dir: newDir)
            self.directory.children?.append(newDir)
            objectWillChange.send()
        } catch {
            print(error)
        }
    }
    
    public func delete(offsets: IndexSet) {
        offsets.forEach { offset in
            try! self.fm.removeItem(at: self.directory.children![offset].url)
        }
        self.directory.children?.remove(atOffsets: offsets)
        objectWillChange.send()
    }
    
    public func move(offsets: IndexSet, destinationIndex: Int) {
        // We just need to change the parent, as well as move the file on the file system (and also, update it in the children)
        offsets.forEach { offset in
            let mover = self.directory.children![offset]
            let destination = self.directory.children![destinationIndex] as! Directory
            
            try! self.fm.moveItem(at: mover.url, to: destination.url)
            
            mover.parent?.children?.remove(at: offset)
            mover.parent = destination
            mover.url = destination.url.appendingPathComponent(mover.url.lastPathComponent)
            destination.children?.append(mover)
        }
        
        objectWillChange.send()
    }
    
    
    
    
    
    
    
}
