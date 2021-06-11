//
//  DirectoryView.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-09.
//

import SwiftUI

struct DirectoryView: View {
    @EnvironmentObject var dirVM: DirectoryViewModel
    
    var body: some View {
        //Text("Directories").foregroundColor(.gray) // We could change the name to match the directory we're in; when we're not in the root directory add a back button?
        
        Button(action: {  } ) {
            Text("\(dirVM.rootDir ? Image(systemName: "folder.circle") : Image(systemName: "chevron.left")) \(dirVM.currentDir ?? "ERROR: Directory Not Found")")
                .foregroundColor(dirVM.rootDir ? .secondary : .primary)
        }.disabled(dirVM.rootDir)
        
        ForEach(dirVM.files) { file in
            if file.type == FileType.DIR {
                Button(action: { dirVM.cDir(dir: file.name) }) {
                    Text("\(Image(systemName: "folder")) \(file.name)")
                }
            } else {
                NavigationLink(destination: (file.type == FileType.DIR ? nil : PDFKitRepresentedView(dirVM.getData(file: file)!))) { Text("\(Image(systemName: (file.type == FileType.DIR ? "folder" : "doc.text"))) \(file.name)") }
            }
            
            
            
            /* TODO:
             Need to support directories; when we click one we should navigate into it, with a back button to go up a level.
             We also need to display the root directory (the Papers directory), with child elements offset from it. Whenever we navigate to a new directory, we put it in place of the parent directory and keep elements offset.
             
             Directories should be sorted either to the top or bottom of the list, but not alphabetically (as then they get mixed in with documents)
             */
            
            // TODO: we shouldn't use PDFKit if we have a directory, so we'll need to separate these somehow (probably in the ViewModel
            //NavigationLink(destination: (file.type == FileType.DIR ? nil : PDFKitRepresentedView(dirVM.getData(file: file)!))) { Text("\(Image(systemName: (file.type == FileType.DIR ? "folder" : "doc.text"))) \(file.name)") }
        }
        
        Button(action: { dirVM.createDir() }) {
            Text("\(Image(systemName: "folder.badge.plus")) Create Directory")
        }
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView()
    }
}
