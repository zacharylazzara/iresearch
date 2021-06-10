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
    
    @IBAction func add() { // We have a lot of duplicate code here shared with the DirectoryView (or its ViewModel); we should try to put this stuff in a single place
        let fm = FileManager.default
        
        let appGroupPath = fm.containerURL(forSecurityApplicationGroupIdentifier: AppGroup.library.containerURL.path)!.path
        let libraryPath = appGroupPath + "/Library/"
        let papersPath = libraryPath + "Papers/"
        
        var safeToWrite = false
        
        if !fm.fileExists(atPath: appGroupPath) && fm.fileExists(atPath: libraryPath) {
            print("Unable to find AppGroup or Library directories!")
            // TODO: we need to display an error to the user
        } else if fm.fileExists(atPath: papersPath) {
            print("Checking files in: \(papersPath)")
            do {
                let files = try fm.contentsOfDirectory(atPath: papersPath)
                print("Found: \(files)")
                
                // TODO: we should ask the user what to do when a conflict is found (for now, just auto-rename)
                
                var checkTitle = pdfTitle!
                var collisions = 0
                
                while files.contains(checkTitle) {
                    checkTitle = pdfTitle!
                    collisions += 1
                    checkTitle = "(\(collisions))\(checkTitle)"
                }
                
                pdfTitle = checkTitle
                safeToWrite = true
            } catch {
                print(error)
            }
        } else {
            print("\(papersPath) does not exist! Creating directory...")
            do {
                try fm.createDirectory(atPath: papersPath, withIntermediateDirectories: true, attributes: nil)
                safeToWrite = true
            } catch {
                print(error)
            }
        }
        
        if safeToWrite {
            pdfDoc!.write(to: URL(fileURLWithPath: papersPath + pdfTitle!))
            
            do {
                print("Found (after writing): \(try fm.contentsOfDirectory(atPath: papersPath))")
            } catch {
                print(error)
            }
        }
        
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}
