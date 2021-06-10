//
//  DirectoryView.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-09.
//

import SwiftUI

struct DirectoryView: View {
    //@ObservedObject var documents: [Document]()
    let fm = FileManager.default
    //@State var documents = [Document]()
    
    var body: some View {
        
        Text("Directories").foregroundColor(.gray)
        
        //fm.contentsOfDirectory(atPath: AppGroup.library.containerURL)
        
        ForEach(load()) { doc in
            Text(doc.title)
        }
        
        
        
        Button(action: create) {
            Text("\(Image(systemName: "folder.badge.plus")) Create Directory")
        }
    }
    
    // TODO: we should move these functions into a ViewModel!
    private func load() -> [Document] {
        var documents = [Document]()
        
        let appGroupPath = fm.containerURL(forSecurityApplicationGroupIdentifier: AppGroup.library.containerURL.path)!.path
        let libraryPath = appGroupPath + "/Library/"
        let papersPath = libraryPath + "Papers/"
        
        if !fm.fileExists(atPath: appGroupPath) && fm.fileExists(atPath: libraryPath) {
            print("Unable to find AppGroup or Library directories!")
            // TODO: we need to display an error to the user
        } else if fm.fileExists(atPath: papersPath) {
            print("Loading files from: \(papersPath)")
            do {
                let files = try fm.contentsOfDirectory(atPath: papersPath)
                print("Found: \(files)")
                            
                for file in files {
                    documents.append(Document(URL(string: papersPath + file)!, type: DocType.PDF, remote: false, title: file, added: Date(), accessed: Date(), tags: [], flagged: false))
                    
                    // TODO: we need to get the date the file was created and accessed from the file manager (or remove these variables if we won't be using them)
                    // We also need to load tags and the document state and other such things from somewhere (maybe CoreData? but then we can have a sync problem if the underlying files change)
                }
            } catch {
                print(error)
            }
        } else {
            print("\(papersPath) does not exist! Creating directory...")
            do {
                try fm.createDirectory(atPath: papersPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        return documents
    }
    
    
    private func create() {
        // This will just add a directory in place which will then be renamed by the user as they'd rename any other folder
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView()
    }
}
