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
            SidebarView()
//            ZStack(alignment: .leading) {
//                // TODO: we might want a list here, and then we'll load the library separate from the sidebar? But we'll see
//                SidebarView()
//            }
//
//
//
//            VStack(alignment: .leading) {
//
//            }
//            .navigationBarTitle(Text(title), displayMode: .inline)
//            .navigationBarItems(
//                trailing: HStack {
////                    switch selection {
////                    case 1:
////                        NavigationLink( // TODO: we want to enable note taking here; perhaps we should use this to hide or unhide our notes?
////                            destination: PDFKitRepresentedView(viewDoc()),//ContentView(),
////                            label: {
////                                Text("\(Image(systemName: "square.and.pencil"))")
////                            }
////                        )//.foregroundColor(.red)
////                    default:
////                        NavigationLink(
////                            destination: PDFKitRepresentedView(viewDoc()),//ContentView(),
////                            label: {
////                                Text("\(Image(systemName: "square"))")
////                            }
////                        )//.foregroundColor(.red)
////                    }
//                })
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
        //self.selection = 0
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
