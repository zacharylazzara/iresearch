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
    
    @IBAction func add() { // We have a lot of duplicate code here shared with the DirectoryViewModel; we should try to put this stuff in a single place if possible
        let fm = FileManager.default
        let documents = AppGroup.documents.containerURL//AppGroup.root.containerURL.appendingPathComponent("Library", isDirectory: true).appendingPathComponent("Papers", isDirectory: true)
        
        print("Root URL: \(documents)")
        
//        if !fm.fileExists(atPath: rootURL.path) {
//            do {
//                print("\(rootURL.lastPathComponent) doesn't exist! Creating directory...")
//                try fm.createDirectory(at: rootURL, withIntermediateDirectories: true, attributes: nil)
//                print("Successfully created \(rootURL.lastPathComponent)!")
//            } catch {
//                print(error)
//                return
//            }
//        }
        
        do {
            let files = try fm.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil)
            print("Found: \(files)")
            
            // TODO: we should ask the user what to do when a conflict is found (for now, just auto-rename)
            
            var uName = pdfTitle!
            var collisions = 0
            
            while files.contains(where: {file in file.lastPathComponent == uName}) {
                uName = pdfTitle!
                collisions += 1
                uName = "(\(collisions))\(uName)"
            }
            
            pdfDoc!.write(to: documents.appendingPathComponent(uName))
            
            do {
                print("Found (after writing): \(try fm.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil))")
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}
