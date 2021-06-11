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
        self.directory.children = loadDir(file: self.directory)
    }
    
    // TODO: we can use .DS_Store to store our custom attributes such as which files are flagged etc
    // TODO: look into  https://developer.apple.com/documentation/appkit/nsoutlineview
    // TODO: Also look into outline groups (this is what we'd use for iOS I think) https://developer.apple.com/documentation/swiftui/outlinegroup
    
    public func loadData(file: File) -> Data {
        return load(file: file)!.1!
    }
    
    public func loadDir(file: File) -> [File] {
        return load(file: file)!.0!
    }
    
    private func load(file: File) -> ([File]?, Data?)? {
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
                
                if child.isDir() {
                    child.children = load(file: child)?.0
                }
                
                children?.append(child)
                children?.sort()
            }
            
            return (children, nil)
        } else {
            print("File is a document")
            
            guard let data = try? Data(contentsOf: file.url) else {
                return nil
            }
            
            return (nil, data)
        }
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
            let newDir = File(url: self.directory.url.appendingPathComponent(uName), name: uName, parent: self.directory)
            try fm.createDirectory(at: newDir.url, withIntermediateDirectories: false, attributes: nil)
            newDir.children = loadDir(file: newDir)
            self.directory.children!.append(newDir)
            
            // TODO: we need to refresh the view somehow
        } catch {
            print(error)
        }
    }
    
    public func delete(file: File) {
        
    }
    
    public func pDir() {
        self.directory = self.directory.parent ?? self.directory
    }
    
    public func cDir(dir: String) {
        self.directory = (self.directory.children!.first(where: { child in child.name == dir }))!
    }
}
