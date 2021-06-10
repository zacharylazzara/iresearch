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
    var pdfTitle: String?

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
                                    self.pdfTitle = pdfURL.lastPathComponent
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
        let fm = FileManager.default
        let dir = fm.containerURL(forSecurityApplicationGroupIdentifier: AppGroup.library.containerURL.path)!.absoluteURL
        
        pdfDoc!.write(to: dir.appendingPathComponent(pdfTitle!))
        
        
        // TODO: figure out what to do with the completionRequest if anything (but for now it works fine)
        
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}
