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
    
    init() {
        fm = FileManager.default
        appGroupPath = fm.containerURL(forSecurityApplicationGroupIdentifier: AppGroup.library.containerURL.path)!.path + "/"
        libraryPath = appGroupPath + "Library/"
        papersPath = libraryPath + "Papers/"
        
        if !fm.fileExists(atPath: appGroupPath) && fm.fileExists(atPath: libraryPath) {
            print("Unable to find AppGroup or Library directories!")
            
            // TODO: we need to display an error to the user (maybe throw an exception?
            
        } else if !fm.fileExists(atPath: papersPath) {
            print("\(papersPath) does not exist! Creating directory...")
            do {
                try fm.createDirectory(atPath: papersPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
    
    public func load() -> [Document] {
        var documents = [Document]()
        var directories = [String]()
        
        print("Loading files from: \(papersPath)")
        do {
            let files = try fm.contentsOfDirectory(atPath: papersPath)
            print("Found: \(files)")
                        
            for file in files {
                let url = URL(fileURLWithPath: papersPath + file)
                
                if let f = try? url.resourceValues(forKeys: [.isDirectoryKey]) {
                    if f.isDirectory! {
                        print("Directory: \(file)")
                        
                        directories.append(file)
                    } else {
                        print("Document: \(file)")
                        
                        documents.append(Document(url, type: DocType.PDF, remote: false, title: file, added: Date(), accessed: Date(), tags: [], flagged: false))
                    }
                } else {
                    print("Problem loading file: \(file)")
                }
            }
                
                // TODO: we need to get the date the file was created and accessed from the file manager (or remove these variables if we won't be using them)
                // We also need to load tags and the document state and other such things from somewhere (maybe CoreData? but then we can have a sync problem if the underlying files change)
            
        } catch {
            print(error)
        }
        
        return documents
    }
    
    public func create() {
        // This will just add a directory in place which will then be renamed by the user as they'd rename any other folder
        
        
        do {
            try fm.createDirectory(atPath: papersPath + "New Folder", withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }
        
        
    }
    
    public func getData(document: Document) -> Data? {
        var data: Data?
        
        do {
            data = try Data(contentsOf: document.id)
        } catch {
            print(error)
        }
        
        return data
    }
}
