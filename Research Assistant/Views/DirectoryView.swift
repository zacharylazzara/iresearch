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
    @State var items = [String]()
    
    var body: some View {
        Text("Directories").foregroundColor(.gray)
        
        //fm.contentsOfDirectory(atPath: AppGroup.library.containerURL)
        
        List {
            ForEach(items, id: \.self) { item in
                Text(item)
            }
        }
        
        
        
        Button(action: create) {
            Text("\(Image(systemName: "folder.badge.plus")) Create Directory")
        }
    }
    
    private func create() {
        
        do {
            //file:///Users/zachary/Library/Developer/CoreSimulator/Devices/46ACAD62-8A28-46AA-9F3E-F1DDE0A47E3C/data/Containers/Shared/AppGroup/6B55B45C-48D3-457C-B1DA-A2088F35F574//
            let dir = fm.containerURL(forSecurityApplicationGroupIdentifier: AppGroup.library.containerURL.path)!.path// + "/Library"
            print(dir)
            items = try fm.contentsOfDirectory(atPath: dir)
            print(items)
            
            for item in items {
                print("Found \(item)")
            }
        } catch {
            print(error)
            // failed to read directory – bad permissions, perhaps?
        }
        // This will just add a directory in place which will then be renamed by the user as they'd rename any other folder
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView()
    }
}
