//
//  SearchView.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-09.
//

import SwiftUI

struct SearchView: View {
    @State private var searchTerm: String = ""
    var body: some View {
        HStack() {
            Text("\(Image(systemName: "magnifyingglass"))")
            TextField("Search", text: $searchTerm)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
