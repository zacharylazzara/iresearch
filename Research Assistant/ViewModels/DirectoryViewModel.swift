//
//  ContentViewModel.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-08.
//

import Foundation

/* TODO:
 - Load PDFs from local storage
 - Load PDFs from web (HTTPS; may need to give an option to allow HTTP as well)
 - Send appropriate view to ContentView
 
 */

class DirectoryViewModel: ObservableObject {
    @Published var contents = [String]()
    
    init() throws {
        try loadDirContents()
    }
    
    func loadDirContents(atPath: String = Bundle.main.resourcePath!) throws {
        let fm = FileManager.default
        contents = try fm.contentsOfDirectory(atPath: atPath)
    }
    
    
    
    
}
