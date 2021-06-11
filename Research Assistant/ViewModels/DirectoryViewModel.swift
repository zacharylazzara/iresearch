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
    private let rootURL: URL
    
    @Published public var directory: File
    @Published public var showHidden: Bool
    
    init() {
        self.fm = FileManager.default
        self.rootURL = AppGroup.library.containerURL.appendingPathComponent("Library", isDirectory: true).appendingPathComponent("Papers", isDirectory: true)
        self.showHidden = false
        
        print("Root URL: \(self.rootURL)")
        
        if !self.fm.fileExists(atPath: self.rootURL.path) {
            do {
                print("\(self.rootURL.lastPathComponent) doesn't exist! Creating directory...")
                try self.fm.createDirectory(at: self.rootURL, withIntermediateDirectories: true, attributes: nil)
                print("Successfully created \(self.rootURL.lastPathComponent)!")
            } catch {
                print(error)
            }
        }
        
        self.directory = File(url: self.rootURL, name: self.rootURL.lastPathComponent)
        try? self.directory.append(files: load(file: self.directory) as? [File], overwrite: true)
    }
    
    // TODO: we can use .DS_Store to store our custom attributes such as which files are flagged etc
    // TODO: look into  https://developer.apple.com/documentation/appkit/nsoutlineview
    // TODO: Also look into outline groups (this is what we'd use for iOS I think) https://developer.apple.com/documentation/swiftui/outlinegroup
    // TODO: we need to auto-update the view when the directory's children change (currently view only updates when the directory changes, but not when it gets new folders)
    
    public func loadData(file: File) -> Data {
        return load(file: file) as! Data
    }
    
    public func loadDir() -> [File] {
        return try! self.directory.read() as! [File]
    }
    
    private func load(file: File) -> Any? {
        print("Loading from file: \(file.name)")
        
        var children: [File]?
        
        if file.isDir() {
            print("File is a directory")
            
            children = [File]()
            let fileChildren: [URL]
            
            do {
                fileChildren = try fm.contentsOfDirectory(at: file.url, includingPropertiesForKeys: nil) // TODO: look into includingPropertiesForKeys, maybe we can get dates and such with it?
            } catch {
                print(error)
                return nil
            }
            
            print("Found: \(fileChildren)")
            
            for url in fileChildren {
                let child = File(url: url, name: url.lastPathComponent, parent: file)
                
                do {
                    if child.isDir() {
                        try child.append(files: load(file: child) as? [File], overwrite: true)
                    }
                } catch {
                    print(error)
                    return nil
                }
                
                children?.append(child)
                children?.sort()
            }
            
            return children
        } else {
            print("File is a document")
            return try! file.read() as! Data
        }
    }
    
    public func createDir(name: String = "New Folder") {
        var uName = name
        var collisions = 0
        
        while (try? self.directory.read() as! [File]?)!.contains(where: {file in file.name == uName}) {
            uName = name
            collisions += 1
            uName = "\(uName)(\(collisions))"
        }
        
        do {
            let newDir = File(url: self.directory.url.appendingPathComponent(uName), name: uName, parent: self.directory)
            try fm.createDirectory(at: newDir.url, withIntermediateDirectories: false, attributes: nil)
            try? newDir.append(files: load(file: newDir) as? [File], overwrite: true)
            try? self.directory.append(files: [newDir])
            
            // TODO: we need to refresh the view somehow! Ideally it would be done as a result of data changing, but if that's not feasible we can just do it here somehow
        } catch {
            print(error)
        }
    }
    
    public func delete(file: File) {
        
    }
    
    public func changeDir(file: File) { // TODO: maybe check to make sure we don't try to change to a data file vs a directory?
        self.directory = file
    }
}
