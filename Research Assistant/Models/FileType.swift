//
//  DocType.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-08.
//

enum FileType: Comparable {
    case PDF
    case DIR
    
    /* TODO:
     Add support for other document types such as:
     - IMG (.png, .jpg, etc)
     - DOC (Microsoft Word, LibreOffice, Google Docs, etc)
     
     Might want to have each one its own case rather than a catch all like IMG or DOC.
     PDF will be the initial focus however as research papers are typically referenced in PDF format.
     */
}
