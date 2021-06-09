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

    //@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pdfView: PDFView!

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
                                    strongPDFView.document = PDFDocument(url: pdfURL)
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
        
        
        
        
        
        
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
//        var imageFound = false
//        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
//            for provider in item.attachments! {
//                if provider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
//                    // This is an image. We'll load it, then place it in our image view.
//                    weak var weakImageView = self.imageView
//                    provider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil, completionHandler: { (imageURL, error) in
//                        OperationQueue.main.addOperation {
//                            if let strongImageView = weakImageView {
//                                if let imageURL = imageURL as? URL {
//                                    strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
//                                }
//                            }
//                        }
//                    })
//
//                    imageFound = true
//                    break
//                }
//            }
//
//            if (imageFound) {
//                // We only handle one image, so stop looking for more.
//                break
//            }
//        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
