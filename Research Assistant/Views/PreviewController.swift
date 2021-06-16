//
//  PreviewController.swift
//  SwiftUIQuickLook
//
//  Created by Наталия Панферова on 14/08/20.
//
//  Obtained from https://github.com/LostMoa/SwiftUI-Code-Examples/blob/main/PreviewFilesWithQuickLookInSwiftUI/SwiftUIQuickLook/PreviewController.swift
//  Modified by Zachary Lazzara on 16/06/2021
//

import SwiftUI
import QuickLook

struct PreviewController: UIViewControllerRepresentable {
    
    let files: [File]
    
    //    func makeUIViewController(context: Context) -> QLPreviewController {
    //        let controller = QLPreviewController()
    //        controller.dataSource = context.coordinator
    //        return controller
    //    }
    //
    //    func updateUIViewController(
    //        _ uiViewController: QLPreviewController, context: Context) {}
    //
    //
    //    func makeCoordinator() -> Coordinator {
    //        return Coordinator(parent: self)
    //    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        //            controller.navigationItem.leftBarButtonItem = UIBarButtonItem(
        //                barButtonSystemItem: .done, target: context.coordinator, action: #selector(context.coordinator.dismiss)
        //            )
        
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    
    
    
    
    
    
    
    
    class Coordinator: QLPreviewControllerDataSource {
        
        let parent: PreviewController
        
        init(parent: PreviewController) {
            self.parent = parent
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return parent.files.count
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.files[index]
        }
        
        // From: https://www.raywenderlich.com/10447506-quicklook-previews-for-ios-getting-started
        func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
            .updateContents
            //.createCopy // TODO: need to make sure that when users edit an already edited file, we don't make a new copy (should have master copy and note copy)
        }
    }
}
