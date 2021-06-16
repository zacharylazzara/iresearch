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
                    NavigationLink(destination: (FileView(id: file.id))) { Text("\(Image(systemName: ("doc.text"))) \(file.name)") }
                }
            }
        }
        .onDelete(perform: delete)
        //.onMove(perform: move) // TODO: get this working at some point (this is a lower priority however so it can be implemented later)
        
        Divider()
        
        Button(action: { dirVM.createDir() }) {
            Text("\(Image(systemName: "folder.badge.plus")) Create Directory")
        }
    }
    
    func delete(offsets: IndexSet) {
        offsets.forEach { offset in
            let file = dirVM.loadDir()[offset]
            print("Deleting \(((file as? Directory) != nil) ? "directory" : "document"): \(file.name)")
            dirVM.delete(offsets: offsets)
        }
    }
    
    func move(offsets: IndexSet, destinationIndex: Int) {
        if !offsets.contains(destinationIndex) { // We can't put our items into themselves, so make sure the offsets don't contain the destination
            dirVM.move(offsets: offsets, destinationIndex: destinationIndex)
        }
        
        
        // TODO: we can use this to move files into other directories; doesn't seem to let us slide to rename though
        // TODO: we should allow the user to re-order the list as well, since they can reorder it by dragging things around. We'll probably need to store this in DS_Store but idk for sure
        
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView()
    }
}
