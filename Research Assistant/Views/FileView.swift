//
//  DocumentView.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-16.
//

import SwiftUI


// TODO: We probably shouldn't be loading the preview controller within another view, since I believe Apple's guidelines say not to do this
// TODO: We need to get animations working properly; right now the file just appears, but it should slide in somehow
// TODO: We need Apple Pencil support and the ability to automatically save changes (we should save changes to a copy, as we want to retain a master copy of the document)


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
        //.navigationBarHidden(true)
        
        
        // TODO: we need to fix the navigation bar or replace the view completely with the selected view. Might want to change how we navigate files based on this.
        /*
         Instead of navigating files via the sidebar we might want instead to have a library tab, which will allow us to navigate the files however we choose. We can then put favourites in the side bar where we currently show files. This is likely the best approach, and fixes other issues such as the side bar going away when we select a directory in portrait mode.
         */
        
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
