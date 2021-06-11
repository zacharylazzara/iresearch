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
 */

class DirectoryViewModel: ObservableObject {
    private let fm: FileManager
    private let appGroupPath: String
    private let libraryPath: String
    private let rootPath: String
    private var currentPath: String
    
    @Published public var files: [File]
    @Published public var currentDir: String?
    @Published public var rootDir: Bool
    
    init() {
        self.fm = FileManager.default
        self.appGroupPath = self.fm.containerURL(forSecurityApplicationGroupIdentifier: AppGroup.library.containerURL.path)!.path + "/"
        self.libraryPath = self.appGroupPath + "Library/"
        self.rootPath = self.libraryPath + "Papers/"
        self.files = [File]()
        rootDir = true
        
        self.currentPath = self.rootPath
        
        if !self.fm.fileExists(atPath: self.appGroupPath) && self.fm.fileExists(atPath: self.libraryPath) {
            print("Unable to find AppGroup or Library directories!")
            
            // TODO: we need to display an error to the user (maybe throw an exception?
            
        } else if !self.fm.fileExists(atPath: self.rootPath) {
            print("\(self.rootPath) does not exist! Creating directory...")
            do {
                try self.fm.createDirectory(atPath: self.rootPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        } else {
            load(path: rootPath) // TODO: we may need to figure out a way to make files observe this? right now it'll only run once and won't update data when data is added
        }
    }
    
    
    // TODO: look into  https://developer.apple.com/documentation/appkit/nsoutlineview
    // TODO: Also look into outline groups (this is what we'd use for iOS I think) https://developer.apple.com/documentation/swiftui/outlinegroup
    
    
    // TODO: load should iterate recursively; we want to make a doubly linked list for our files
//    var root: File
//
//    private func load(file: File) throws {
//        fm.changeCurrentDirectoryPath(file.description)
//        root.children = try fm.contentsOfDirectory(atPath: fm.currentDirectoryPath)
//
//
//
//    }
//
    
    private func load(path: String) {
        currentPath = path
        currentDir = URL(fileURLWithPath: currentPath).lastPathComponent
        
        if currentPath == rootPath {
            rootDir = true
        } else {
            rootDir = false
        }
        
        self.files.removeAll()
        print("Loading files from: \(path)")
        do {
            let dirContents = try fm.contentsOfDirectory(atPath: path)
            print("Found: \(dirContents)")
                        
            for filename in dirContents {
                let url = URL(fileURLWithPath: path + filename)
                
                let docType: FileType
                
                if let f = try? url.resourceValues(forKeys: [.isDirectoryKey]) {
                    if f.isDirectory! {
                        docType = FileType.DIR
                    } else {
                        docType = FileType.PDF
                    }
                    self.files.append(File(url, type: docType, name: filename))
                } else {
                    print("Problem loading file: \(filename)")
                }
            }
            files.sort()
        } catch {
            print(error)
        }
    }
    
    public func createDir(name: String = "New Folder") {
        var uName = name
        var collisions = 0
        
        while self.files.contains(where: {file in file.name == uName}) {
            uName = name
            collisions += 1
            uName = "\(uName)(\(collisions))"
        }
        
        do {
            try fm.createDirectory(atPath: currentPath + uName, withIntermediateDirectories: true, attributes: nil)
            load(path: currentPath)
        } catch {
            print(error)
        }
    }
    
    public func delete(file: File) {
        
    }
    
    public func cDir(dir: String) {
        load(path: currentPath + dir)
    }
    
    
    
    public func getData(file: File) -> Data? {
        var data: Data?
        
        do {
            data = try Data(contentsOf: file.id)
        } catch {
            print(error)
        }
        
        return data
    }
}
