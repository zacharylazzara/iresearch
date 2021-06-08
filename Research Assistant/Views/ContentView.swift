//
//  ContentView.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-07.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    //@ObservedObject var directoryViewModel: DirectoryViewModel
    
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Document.timestamp, ascending: true)],
    //        animation: .default)
    //    private var docs: FetchedResults<Document>
    
    @State private var searchTerm: String = ""
    @State private var selection: Int?
    @State private var title: String = "Home"
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                // TODO: This is where all the navigation links will be to other features of the app? This is the side bar (maybe we want to have our library listed in here and use the main slide for our PDF?
                
                // TODO: maybe the library should be the home page somehow? Or at the very least it should remember where you left off.
                
                //                Button(action: home) {
                //                    Text("\(Image(systemName: "house.fill")) Home")
                //                }
                
                
                List { // TODO: we might want two lists put in a VStack to make this work better
                    
                    Group {
                        HStack() {
                            Text("\(Image(systemName: "magnifyingglass"))")
                            TextField("Search", text: $searchTerm)
                        }
                        
                        Button(action: home) {
                            Text("\(Image(systemName: "doc.text.magnifyingglass")) Advanced Search")
                        }
                    }
                    
                    Divider()
                    
                    Group {
                        Button(action: home) {
                            Text("\(Image(systemName: "tray.and.arrow.down.fill")) Import Documents")
                        }
                        
                        Button(action: home) {
                            Text("\(Image(systemName: "text.quote")) Generate Citations")
                        }
                        
                        Button(action: doc) {
                            Text("\(Image(systemName: "rectangle.and.paperclip")) Notes")
                        }
                        
                        Button(action: home) {
                            Text("\(Image(systemName: "bookmark.fill")) Bookmarks")
                        }
                        
                        Button(action: home) {
                            Text("\(Image(systemName: "archivebox.fill")) Archive")
                        }
                    }
                    
                    Divider()
                    
                    Group {
                        Text("Directories").foregroundColor(.gray)
                        
                        // TODO: Anchor this to bottom of screen (might need to use a ZStack and VStack, and put it outside the list; not sure yet)
                        Button(action: home) {
                            Text("\(Image(systemName: "folder.badge.plus")) Create Directory")
                        }
                    }
                    
                    
                    
                    
                    
                    //                    ForEach(docs) { item in
                    //                        Text("test")
                    //                    }
                }
                
                //                List {
                //                    ForEach(items) { item in
                //                        Text("Test \(item.timestamp!, formatter: itemFormatter)")
                //                    }
                //                    .onDelete(perform: deleteDocs)
                //                }
            }
            .navigationBarTitle("Library")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: home) {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
            })
            
            VStack(alignment: .leading) {
                // TODO: maybe we should use a view model for this? Since we'll be loading the data through the view model after all, so need to generate the links anyway.
                
                
                //NavigationLink(destination: Text("Home"), tag: 0, selection: $selection) { HomeView() }.hidden().navigationViewStyle(StackNavigationViewStyle())
                HomeView()
                NavigationLink(destination: Text("Doc"), tag: 1, selection: $selection) { PDFKitRepresentedView(viewDoc()) }.hidden().navigationBarBackButtonHidden(true)
                //.navigationViewStyle(StackNavigationViewStyle())
            }
            .navigationBarTitle(Text(title), displayMode: .inline)
            .navigationBarItems(
                trailing: HStack {
//                    switch selection {
//                    case 1:
//                        NavigationLink( // TODO: we want to enable note taking here; perhaps we should use this to hide or unhide our notes?
//                            destination: PDFKitRepresentedView(viewDoc()),//ContentView(),
//                            label: {
//                                Text("\(Image(systemName: "square.and.pencil"))")
//                            }
//                        )//.foregroundColor(.red)
//                    default:
//                        NavigationLink(
//                            destination: PDFKitRepresentedView(viewDoc()),//ContentView(),
//                            label: {
//                                Text("\(Image(systemName: "square"))")
//                            }
//                        )//.foregroundColor(.red)
//                    }
                })
            //.navigationBarBackButtonHidden(true)
        }
        //.navigationViewStyle(StackNavigationViewStyle())
        
        
        
        //        List {
        //            ForEach(items) { item in
        //                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
        //            }
        //            .onDelete(perform: deleteItems)
        //        }
        //        .toolbar {
        //            #if os(iOS)
        //            EditButton()
        //            #endif
        //
        //            Button(action: addItem) {
        //                Label("Add Item", systemImage: "plus")
        //            }
        //        }
    }
    
    private func home() {
        self.title = "Home"
        self.selection = 0
    }
    
    private func doc() {
        self.title = docTitle()!
        self.selection = 1
    }
    
    private func docTitle() -> String? { // TODO: we'll need to not hardcode this soon
        return URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")?.lastPathComponent
    }
    
    private func viewDoc() -> Data {
        do {
            // TODO: this app transport thing is blocked (it wants HTTPS)
            return try Data(contentsOf: URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")!)
        } catch {
            // TODO: throw error, unable to load document
            fatalError()
        }
    }
    
    private func addDoc() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteDocs(offsets: IndexSet) {
        withAnimation {
            //offsets.map { docs[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
