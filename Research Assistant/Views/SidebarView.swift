//
//  SidebarView.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-09.
//

import SwiftUI

struct SidebarView: View {
    @State private var selection: Int? = 1
    @State private var title: String = "Home"
    
    
    // TODO: For some reason the first view doesn't load unless we open the sidebar. This isn't an issue in landscape, but in portrait mode it is an issue
    
    
    var body: some View {
        List {
            Group {
                SearchView() // TODO: seems to be some problems with having this as its own view, need to investigate further
                NavigationLink(destination: AdvancedSearchView(), tag: 1, selection: $selection) { Text("\(Image(systemName: "doc.text.magnifyingglass")) Advanced Search") }
            }
            
            Divider()
            
            Group {
                NavigationLink(destination: AutoLiteratureReviewView(), tag: 2, selection: $selection) { Text("\(Image(systemName: "tray.and.arrow.down.fill")) Auto-Literature Review") }
                NavigationLink(destination: CitationGeneratorView(), tag: 3, selection: $selection) { Text("\(Image(systemName: "text.quote")) Generate Citations") }
                NavigationLink(destination: NotesView(), tag: 4, selection: $selection) { Text("\(Image(systemName: "rectangle.and.paperclip")) Notes") }
                NavigationLink(destination: BookmarksView(), tag: 5, selection: $selection) { Text("\(Image(systemName: "bookmark.fill")) Bookmarks") }
                NavigationLink(destination: ArchiveView(), tag: 6, selection: $selection) { Text("\(Image(systemName: "archivebox.fill")) Archive") }
            }
            
            Divider()
            
            DirectoryView()
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
        
        // TODO: needs to open the navigation link somehow (alternatively we can just edit settings within the sidebar by putting the navlink in the toolbar
    }
    
    private func search() {
        self.title = "Advanced Search"
        self.selection = 1
    }
    
    private func autoLitRev() {
        self.title = "Auto-Literature Review"
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
    
    
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
