//
//  ActionViewController.swift
//  Library Extension
//
//  Created by Zachary Lazzara on 2021-06-09.
//

import UIKit
import MobileCoreServices
import PDFKit

class ActionViewController: UIViewController {
    @IBOutlet weak var pdfView: PDFView!
    var pdfDoc: PDFDocument?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        var pdfFound = false
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(kUTTypePDF as String) {
                    weak var weakPDFView = self.pdfView
                    provider.loadItem(forTypeIdentifier: kUTTypePDF as String, options: nil, completionHandler: { (pdfURL, error) in
                        OperationQueue.main.addOperation {
                            if let strongPDFView = weakPDFView {
                                if let pdfURL = pdfURL as? URL {
                                    self.pdfDoc = PDFDocument(url: pdfURL)
                                    strongPDFView.document = self.pdfDoc
                                    strongPDFView.autoScales = true
                                }
                            }
                        }
                    })
                    pdfFound = true
                    break
                }
            }
            if (pdfFound) {
                break
            }
        }
    }
    
    @IBAction func add() {
        let libraryURL = AppGroup.library.containerURL.appendingPathComponent(DateFormatter().string(from: Date()))
        print(libraryURL)
        pdfDoc!.write(to: libraryURL)
        
        
        //file:///Users/zachary/Library/Developer/CoreSimulator/Devices/46ACAD62-8A28-46AA-9F3E-F1DDE0A47E3C/data/Containers/Shared/AppGroup/6B55B45C-48D3-457C-B1DA-A2088F35F574//
        
        //file:///Users/zachary/Library/Developer/CoreSimulator/Devices/46ACAD62-8A28-46AA-9F3E-F1DDE0A47E3C/data/Containers/Shared/AppGroup/EC95947A-B81A-4DDA-AAE7-8A4E3E069C14//
        
        // TODO: figure out what to do with the completionRequest
        
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}
