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

struct AutoLiteratureReviewView: View {
    @State private var link: String = "" // TODO: download from link somehow
    
    /* TODO:
     We're gonna want to utilize the share menu so we can easily send documents to the app; perhaps we shouldn't even offer the link download option under Import?
     */
    
    // TODO: change this to be the auto-literature review system
    
    var body: some View {
        VStack(alignment: .leading) {
            // TODO: we should use a viewmodel to search the library for supporting papers
            // TODO: controls to upload thesis here
            Button(action: search) {
                Image(systemName: "highlighter")
                Text("Begin Auto-Literature Review")
            }
            
        }
        .navigationTitle("Auto-Literature Review")
        Spacer()
    }
    
    private func search() {
        /* TODO:
         Upload thesis (need a Word plugin, maybe even the ability to pull form Word? could do OneDrive integration so we can pull relevant files directly?)
         Search through library
         Search through databases (maybe)
         */
    }
    
    
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        AutoLiteratureReviewView()
    }
}
