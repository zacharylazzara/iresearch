//
//  DirectoryView.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-09.
//

import SwiftUI

struct DirectoryView: View {
    //@ObservedObject var documents: [Document]()
    
    var body: some View {
        Text("Directories").foregroundColor(.gray)
        
        Button(action: create) {
            Text("\(Image(systemName: "folder.badge.plus")) Create Directory")
        }
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
