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
    private let papersPath: String
    
    @Published public var files: [File]
    
    init() {
        self.fm = FileManager.default
        self.appGroupPath = self.fm.containerURL(forSecurityApplicationGroupIdentifier: AppGroup.library.containerURL.path)!.path + "/"
        self.libraryPath = self.appGroupPath + "Library/"
        self.papersPath = self.libraryPath + "Papers/"
        self.files = [File]()
        
        if !self.fm.fileExists(atPath: self.appGroupPath) && self.fm.fileExists(atPath: self.libraryPath) {
            print("Unable to find AppGroup or Library directories!")
            
            // TODO: we need to display an error to the user (maybe throw an exception?
            
        } else if !self.fm.fileExists(atPath: self.papersPath) {
            print("\(self.papersPath) does not exist! Creating directory...")
            do {
                try self.fm.createDirectory(atPath: self.papersPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        } else {
            load() // TODO: we may need to figure out a way to make files observe this? right now it'll only run once and won't update data when data is added
        }
    }
    
    private func load() {
        self.files.removeAll()
        print("Loading files from: \(papersPath)")
        do {
            let dirContents = try fm.contentsOfDirectory(atPath: papersPath)
            print("Found: \(dirContents)")
                        
            for filename in dirContents {
                let url = URL(fileURLWithPath: papersPath + filename)
                
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
    
    public func createDirWrapper() { // Using this wrapper for now so we can have optional parameters when creating directories, while still creating them with a Button
        createDir()
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
            try fm.createDirectory(atPath: papersPath + uName, withIntermediateDirectories: true, attributes: nil)
            load()
        } catch {
            print(error)
        }
    }
    
    public func delete(file: File) {
        
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
