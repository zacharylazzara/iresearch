//
//  ImportView.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-09.
//

/* TODO:
 - Import from HTTPS links (give warning when using HTTP but allow users to override if they want to)
 - Import from external databases (may be unable to implement this depending on database APIs)
 - Import from scanned documents (camera; allow photos and also pulling text from photos and converting to text format (keep original photo in these cases, just in case))
 - Import from cloud/network drives
 - iCloud integration (automatically synchronize between device and iCloud if user allows it)
 */

import SwiftUI

struct ImportView: View {
    @State private var link: String = "" // TODO: download from link somehow
    
    /* TODO:
     We're gonna want to utilize the share menu so we can easily send documents to the app; perhaps we shouldn't even offer the link download option under Import?
     */
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Button(action: download) {
                    Image(systemName: "doc.text.viewfinder")
                    Text("Photo Scan")
                }
                
                Button(action: download) {
                    Image(systemName: "books.vertical.fill")
                    Text("Database")
                }
            }
            
            HStack() {
                Button(action: download) {
                    Image(systemName: "externaldrive.fill.badge.wifi")
                    Text("Network")
                }
                
                Button(action: download) {
                    Image(systemName: "externaldrive.fill.badge.icloud")
                    Text("Cloud")
                }
            }
        }
        .navigationTitle("Import")
        Spacer()
    }
    
    private func download() {
        
    }
    
    
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView()
    }
}
