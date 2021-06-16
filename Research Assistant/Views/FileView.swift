//
//  DocumentView.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-16.
//

import SwiftUI

struct FileView: View {
    //@EnvironmentObject var dirVM: DirectoryViewModel // TODO: we may need this later so we can save files and keep track of their changes
    @State var files: [File]?
    
    var body: some View {
        VStack(alignment: .leading) {
            if (files == nil) {
                ProgressView()
            } else {
                PreviewController(files: files!)
            }
        }
        
        // TODO: the file count doesn't update when we delete or create a file (we likely need a binding variable or to use the environment object)
        
        .navigationTitle(files?.count ?? 0 < 2 ? (files?.indices.contains(0))! ? files?[0].name ?? "Loading..." : "Empty Directory" : "\(files!.count) Files")
//        .onAppear() { // May use this (or something like this) later if we need to save files
//            //files = dirVM.loadDir().filter({ file in ids.contains(file.id) })
//        }
    }
}

// TODO: if we want to use the preview we need to initialize the environment object as well (for now it's not worth doing, but perhaps in the future it should be done)
//struct FileView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileView(id: AppGroup.library.containerURL)
//    }
//}
