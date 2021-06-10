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
        Text("Directories").foregroundColor(.gray)
        
        ForEach(dirVM.load()) { doc in
            /* TODO:
             Need to support directories; when we click one we should navigate into it, with a back button to go up a level.
             We also need to display the root directory (the Papers directory), with child elements offset from it. Whenever we navigate to a new directory, we put it in place of the parent directory and keep elements offset.
             
             Directories should be sorted either to the top or bottom of the list, but not alphabetically (as then they get mixed in with documents)
             */
            
            // TODO: we shouldn't use PDFKit if we have a directory, so we'll need to separate these somehow (probably in the ViewModel
            NavigationLink(destination: PDFKitRepresentedView(dirVM.getData(document: doc)!)) { Text("\(Image(systemName: (doc.type == DocType.DIR ? "folder" : "doc.text"))) \(doc.title)") }
        }
        
        Button(action: dirVM.create) {
            Text("\(Image(systemName: "folder.badge.plus")) Create Directory")
        }
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView()
    }
}
