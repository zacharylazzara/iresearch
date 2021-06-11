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
        Button(action: { dirVM.changeDir(dir: dirVM.directory.parent!) } ) {
            Text("\(dirVM.directory.isRoot() ? Image(systemName: "folder.circle") : Image(systemName: "chevron.left")) \(dirVM.directory.name)")
                .foregroundColor(dirVM.directory.isRoot() ? .secondary : .primary)
        }.disabled(dirVM.directory.isRoot())
        
        ForEach(dirVM.loadDir()) { file in
            if !file.isHidden() || dirVM.showHidden {
                if let dir = file as? Directory {
                    Button(action: { dirVM.changeDir(dir: dir) }) {
                        Text("\(Image(systemName: "folder")) \(file.name)")
                    }
                } else {
                    NavigationLink(destination: (PDFKitRepresentedView(dirVM.loadData(doc: file as! Document)))) { Text("\(Image(systemName: ("doc.text"))) \(file.name)") }
                }
            }
        }.onDelete(perform: delete)
        
        Button(action: { dirVM.createDir() }) {
            Text("\(Image(systemName: "folder.badge.plus")) Create Directory")
        }
    }
    
    func delete(offsets: IndexSet) {
        offsets.forEach { offset in
            let file = dirVM.loadDir()[offset]
            print("Deleting \(((file as? Directory) != nil) ? "directory" : "document"): \(file.name)")
            //dirVM.delete(offsets: offsets)
        }
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView()
    }
}
