//
//  DocumentView.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-16.
//

import SwiftUI

struct FileView: View {
    @EnvironmentObject var dirVM: DirectoryViewModel
    //let ids: [URL]
    @State var files: [File]?
    
    var body: some View {
        VStack(alignment: .leading) {
            if (files == nil) {
                ProgressView()
            } else {
                PreviewController(files: files!)
            }
        }
        .navigationTitle(files?.count ?? 0 < 2 ? (files?.indices.contains(0))! ? (files?[0].name ?? "Loading...") : "Empty Directory" : "\(files!.count) Documents")
        .onAppear() {
            //files = dirVM.loadDir().filter({ file in ids.contains(file.id) }) // TODO: we can preview entire folders like this if we load only children of the folder
        }
    }
}

// TODO: if we want to use the preview we need to initialize the environment object as well (for now it's not worth doing, but perhaps in the future it should be done)
//struct FileView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileView(id: AppGroup.library.containerURL)
//    }
//}
