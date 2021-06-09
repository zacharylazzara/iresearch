//
//  SidebarView.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-09.
//

import SwiftUI

struct SidebarView: View {
    //@ObservedObject var documents: [Document]()
    
    @State private var searchTerm: String = ""
    @State private var selection: Int? // TODO: needs to bind? the parent view needs access to these variables I think
    @State private var title: String = "Home"
    
    var body: some View {
        List {
            Group {
                HStack() {
                    Text("\(Image(systemName: "magnifyingglass"))")
                    TextField("Search", text: $searchTerm)
                }
                NavigationLink(destination: SearchView(), tag: 1, selection: $selection) { Text("\(Image(systemName: "doc.text.magnifyingglass")) Advanced Search") }
            }
            
            Divider()
            
            Group {
                NavigationLink(destination: ImportView(), tag: 2, selection: $selection) { Text("\(Image(systemName: "tray.and.arrow.down.fill")) Import Documents") }
                NavigationLink(destination: CitationGeneratorView(), tag: 3, selection: $selection) { Text("\(Image(systemName: "text.quote")) Generate Citations") }
                NavigationLink(destination: NotesView(), tag: 4, selection: $selection) { Text("\(Image(systemName: "rectangle.and.paperclip")) Notes") }
                NavigationLink(destination: BookmarksView(), tag: 5, selection: $selection) { Text("\(Image(systemName: "bookmark.fill")) Bookmarks") }
                NavigationLink(destination: ArchiveView(), tag: 6, selection: $selection) { Text("\(Image(systemName: "archivebox.fill")) Archive") }
            }
            
            Divider()
            
            Group {
                Text("Directories").foregroundColor(.gray)
                
                // TODO: Anchor this to bottom of screen (might need to use a ZStack and VStack, and put it outside the list; not sure yet)
                Button(action: create) {
                    Text("\(Image(systemName: "folder.badge.plus")) Create Directory")
                }
            }
        }
        .navigationBarTitle("Library")
        .listStyle(SidebarListStyle())
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: settings) {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
        })
    }
    
    private func settings() {
        self.title = "Settings"
        self.selection = 0
    }
    
    private func search() {
        self.title = "Advanced Search"
        self.selection = 1
    }
    
    private func importDocs() {
        self.title = "Import"
        self.selection = 2
    }
    
    private func citations() {
        self.title = "Generate Citations"
        self.selection = 3
    }
    
    private func notes() {
        self.title = "Notes"
        self.selection = 4
    }
    
    private func bookmarks() {
        self.title = "Bookmarks"
        self.selection = 5
    }
    
    private func archive() {
        self.title = "Archive"
        self.selection = 6
    }
    
    private func create() {
        self.title = "Create Directory"
        // This will just add a directory in place which will then be renamed by the user as they'd rename any other folder
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
