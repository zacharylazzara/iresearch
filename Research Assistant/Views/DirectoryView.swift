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
        Button(action: { dirVM.pDir() } ) {
            Text("\(dirVM.directory.isRoot() ? Image(systemName: "folder.circle") : Image(systemName: "chevron.left")) \(dirVM.directory.name)")
                .foregroundColor(dirVM.directory.isRoot() ? .secondary : .primary)
        }.disabled(dirVM.directory.isRoot())
        
        ForEach(dirVM.loadDir()) { file in
            if !file.isHidden() || dirVM.showHidden {
                if file.isDir() {
                    Button(action: { dirVM.cDir(dir: file.name) }) {
                        Text("\(Image(systemName: "folder")) \(file.name)")
                    }
                } else {
                    NavigationLink(destination: (file.isDir() ? nil : PDFKitRepresentedView(dirVM.loadData(file: file)))) { Text("\(Image(systemName: (file.isDir() ? "folder" : "doc.text"))) \(file.name)") }
                }
            }
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
