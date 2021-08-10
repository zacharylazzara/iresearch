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
import PDFKit
import UniformTypeIdentifiers

struct AutoLiteratureReviewView: View {
    @EnvironmentObject var dirVM: DirectoryViewModel
    @EnvironmentObject var analysisVM: AnalysisViewModel
    @State private var link: String = "" // TODO: download from link somehow
    private let cgfWidth: CGFloat = 5
    private let cgfHeight: CGFloat = 20
    
    // From: http://dx.doi.org/10.1016/j.neunet.2016.11.003
    // Using this text for testing purposes for now.
    //@State private var citation: String = "The hard problem of consciousness is the problem of explaining how we experience qualia or phenome- nal experiences, such as seeing, hearing, and feeling, and knowing what they are. To solve this problem, a theory of consciousness needs to link brain to mind by modeling how emergent properties of several brain mechanisms interacting together embody detailed properties of individual conscious psychologi- cal experiences. This article summarizes evidence that Adaptive Resonance Theory, or ART, accomplishes this goal. ART is a cognitive and neural theory of how advanced brains autonomously learn to attend, rec- ognize, and predict objects and events in a changing world. ART has predicted that ‘‘all conscious states are resonant states’’ as part of its specification of mechanistic links between processes of consciousness, learning, expectation, attention, resonance, and synchrony. It hereby provides functional and mechanistic explanations of data ranging from individual spikes and their synchronization to the dynamics of con- scious perceptual, cognitive, and cognitive–emotional experiences. ART has reached sufficient maturity to begin classifying the brain resonances that support conscious experiences of seeing, hearing, feeling, and knowing. Psychological and neurobiological data in both normal individuals and clinical patients are clarified by this classification. This analysis also explains why not all resonances become conscious, and why not all brain dynamics are resonant. The global organization of the brain into computationally com- plementary cortical processing streams (complementary computing), and the organization of the cerebral cortex into characteristic layers of cells (laminar computing), figure prominently in these explanations of conscious and unconscious processes. Alternative models of consciousness are also discussed."
    
    // From: DOI 10.1007/s11023-014-9352-8
    // Using this text for testing purposes for now.
    //@State private var thesis: String = "If a brain is uploaded into a computer, will consciousness continue in digital form or will it end forever when the brain is destroyed? Philosophers have long debated such dilemmas and classify them as questions about personal identity. There are currently three main theories of personal identity: biological, psycho- logical, and closest continuer theories. None of these theories can successfully address the questions posed by the possibility of uploading. I will argue that uploading requires us to adopt a new theory of identity, psychological branching identity. Psychological branching identity states that consciousness will continue as long as there is continuity in psychological structure. What differentiates this from psychological identity is that it allows identity to continue in multiple selves. According to branching identity, continuity of consciousness will continue in both the original brain and the upload after nondestructive uploading. Branching identity can also resolve long standing questions about split-brain syndrome and can provide clear predictions about identity in even the most difficult cases imagined by philosophers."
    
    @State private var tKeywords: Array<String> = []
    @State private var cKeywords: Array<String> = []
    
    @State private var importFile: Bool = false
    private let importingContentTypes: [UTType] = [UTType(filenameExtension: "pdf")].compactMap { $0 }
    
    @State private var depth: Double = 10.0 // Number of reference sentences to compare. If 0 we will compare all sentences.
    @State private var distance: Double = 0.9 // How simimlar should citaitons be; closer to 0 is more similar
    @State private var isLibraryEmpty: Bool = false
    
    
    //    private var nlViewModel = NaturalLanguageViewModel(doc1: "", doc2: "")
    
    /* TODO:
     We're gonna want to utilize the share menu so we can easily send documents to the app; perhaps we shouldn't even offer the link download option under Import?
     */
    
    // TODO: change this to be the auto-literature review system
    
    var body: some View {
        VStack(alignment: .leading) {
//            Button(action: { analyse() }) {
//                Text("\(Image(systemName: "doc.text.magnifyingglass")) Begin Analysis")
//            }
            /* TODO:
             This view will need to be a list view allowing the user to compare a number of documents. The most relevant document can be put at the top of the list.
             Documents in the list should display a relevance score, this will be based on keywords.
             
             Rather than searching through all documents at first, we can allow the user to select specific documents to search, or search all. We will determine the initial relevancy based on keyword matching. When matching keywords we must take into account the nearest neighbours of each word (words with similar meanings should be included in the matching process, but perhaps with slightly less weight than directly matching words). We may also want to compare abstracts before comparing full documents, as comparing the full document can take a very long time.
             */
            
            
            // TODO: we'll need a way to specify pages later; then we can allow the user to select which pages they wish to analyse. Also need to let them select which documents.
            // In general we need more tuning controls for the user.
            
            // TODO: we need to figure out how to prevent the system from running out of RAM when analysing large documents. The system should never crash, and should be able
            // to analyse documents of any size without any slowdowns. The system should also be able to analyse documents when the app is in the background.
            
            HStack(alignment: .center) {
                if !analysisVM.analysisStarted {
                    VStack(alignment: .leading) {
                        Slider(value: $depth, in: 10...510, step: 10)
                        HStack(alignment: .center) {
                            Text("Analysis Depth:").bold()
                            Text("\(depth > 500 ? "All" : String(Int(depth))) reference sentences")
                        }
                        Slider(value: $distance, in: 0...1)
                        HStack(alignment: .center) {
                            Text("Similarity Threshold:").bold()
                            Text("\(distance < 0.5 ? "High" : distance < 0.8 ? "Medium" : "Low") reference similarity (>\(Int((1 - distance) * 100))%)")
                        }
                        Divider()
                        Button(action: { importFile = true }) {
                            Text("\(Image(systemName: "doc.text.magnifyingglass")) Select Thesis")
                        }
                    }
                } else if analysisVM.percent >= 100 {
                    Text("Analysis Complete").bold()
                } else {
                    Text("Depth:").bold()
                    Text("\(Int(depth)) Sentences")
                    Divider().frame(height: cgfHeight)
                    Text("Threshold:").bold()
                    Text(">\(Int((1 - distance) * 100))% Similarity")
                    Divider().frame(height: cgfHeight)
                    Text("Analysis Progress:").bold()
                    Text("\(analysisVM.percent)% (\(analysisVM.compareProgress)/\(analysisVM.sentCapacity))")
                }
            }
            
            if analysisVM.analysisStarted {
                Divider()
                
                if isLibraryEmpty {
                    VStack(alignment: .center) {
                        Spacer()
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Your library is empty!")
                            Spacer()
                        }
                    }
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Select your thesis to begin")
                        Spacer()
                    }
                }
            }
            
            VStack(alignment: .leading) {
                List {
                    ForEach(analysisVM.args, id: \.self) { tArg in
                        if tArg.args.count > 0 {
                            HStack(alignment: .top) {
                                Color.blue.frame(width: cgfWidth)
                                VStack(alignment: .leading) {
                                    Text("Thesis Statement:").bold()
                                    tArgView(cgfWidth: cgfWidth, arg: tArg).fixedSize(horizontal: false, vertical: true)
                                    Divider()
                                    Text("Citation Statement(s):").bold()
                                    ForEach(tArg.args, id: \.self) { cArg in
                                        cArgView(cgfWidth: cgfWidth, cgfHeight: cgfHeight, arg: cArg).fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                    }
//                    HStack(alignment: .center) {
//                        Spacer()
//                        if nlVM.compareProgress <= 0 {
//                            Button(action: { analyse() }) {
//                                Text("\(Image(systemName: "doc.text.magnifyingglass")) Begin Analysis")
//                            }
//                        } else if nlVM.percent >= 100 {
//                            Text("Analysis Complete").bold()
//                        } else {
//                            Text("Analysis Progress:").bold()
//                            Text("\(nlVM.percent)% (\(nlVM.compareProgress)/\(nlVM.totalCompares))")
//                        }
//                        Spacer()
//                    }
                }
                ProgressView(value: analysisVM.progress)
                Text("Keywords:").bold()
                Text("\(analysisVM.keywordStr)")
            }
        }
        .padding()
        .navigationTitle("Auto-Literature Review")
        .fileImporter(isPresented: $importFile, allowedContentTypes: importingContentTypes, onCompletion: {file in
            // TODO: whatever processing we need to do here
            //file.get() // TODO: get the URL?
            do {
                if let pdf = PDFDocument(url: try file.get()) {
                    analyse(thesis: readPDF(pdf: pdf))
                }
            } catch {
                print(error)
            }
        })
        .alert(isPresented: self.$isLibraryEmpty){
            return Alert(title: Text("Empty Library"), message: Text("Róka can only perform auto-literature review if your thesis and references are not empty!"), dismissButton: .default(Text("Dismiss")))
        }
        
        Spacer()
    }
    
    
    /* TODO:
     We need to scan through all directories within the library, and pull all relevant papers. Perhaps we can match keywords to determine relevance before we commit further computer resources.
     The thesis should be uploaded from outside the app. A file picker should show up allowing the user to select their thesis PDF.
     */
    
    private func analyse(thesis: String) {
        let docs = loadDocs()
        var citation = ""
        
        if docs.count > 0 {
            docs.forEach { doc in
                citation.append(doc)
            }
        }
        
        do {
            try analysisVM.analyse(for: thesis, from: citation, depth: Int((depth > 500 ? 0 : depth)), distanceThreshold: distance)
        } catch {
            print(error)
            isLibraryEmpty = true
        }

        /*
         For now I'll be testing the functionality of the natural language view model by testing it here.
         Will need to make a dictionary or list of all the texts in the repository, so that we can search through everything to find the relevant papers.
         */
        
        // TODO: Now we should be able to start making dictionaries of similarity and use the sentiment to roughly determine level of agreement
        // This may be of value: https://www.slideshare.net/vicknickkgp/analyzing-arguments-during-a-debate-using-natural-language-processing-in-python
        
        //print(nlViewModel.citations(for: thesis, from: citation))
        
    }
    
    private func loadDocs() -> [String] {
        // TODO: this will probably need to be recursive, as we need to scan the entire directory and load all PDFs before loading all documents in child directories.
        // This can be achieved with recursion. Probably don't need to worry about ordering, as we'll continue from where we left off, thus reaching all files eventually.
        
        var documents: Array<String> = [] // TODO: this should be a dictionary instead of an array; we need to put the title as the key
        dirVM.loadDir().forEach { file in
            if !file.isHidden() || dirVM.showHidden {
                if let dir = file as? Directory {
                    // File is a directory
                    // TODO: we'll want to navigate through and load all subdirectories as well
                    
//                    Button(action: { changeDir(dir: dir) }) {
//                        Text("\(Image(systemName: "folder")) \(file.name)")
//                    }
                } else {
                    // File is not a directory
                    
                    // TODO: we should make sure the file type is a supported type (in this case a pdf)
                    
                    
                    // Adapted from: https://www.hackingwithswift.com/example-code/libraries/how-to-extract-text-from-a-pdf-using-pdfkit
                    
                    
                    
                    
                    
                    
                    if let pdf = PDFDocument(url: file.url) {
                        documents.append(readPDF(pdf: pdf))
                        
                        
//
//                        let pageCount = pdf.pageCount
//                        let documentContent = NSMutableAttributedString()
//
//                        for i in 0 ..< pageCount {
//                            guard let page = pdf.page(at: i) else { continue }
//                            guard let pageContent = page.attributedString else { continue }
//                            documentContent.append(pageContent)
//                        }
//                        documents.append(documentContent.string)
                    }
                }
            }
        }
        return documents
    }
    
    private func readPDF(pdf: PDFDocument) -> String {
        let pageCount = pdf.pageCount
        let documentContent = NSMutableAttributedString()

        for i in 0 ..< pageCount {
            guard let page = pdf.page(at: i) else { continue }
            guard let pageContent = page.attributedString else { continue }
            documentContent.append(pageContent)
        }
        return documentContent.string
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

struct tArgView: View {
    let cgfWidth:CGFloat
    var arg: Argument
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("\(arg.sentence)\n")
                
                HStack(alignment: .top) {
                    Text("Sentiment:").bold()
                    Text("\(arg.sentiment == 0 ? "Neutral" : arg.sentiment > 0 ? "Positive" : "Negative")")
                }
            }
            Spacer()
        }
    }
}

struct cArgView: View {
    let cgfWidth: CGFloat
    let cgfHeight: CGFloat
    var arg: Argument
    
    var body: some View {
        HStack(alignment: .top) {
            if arg.supporting! {
                Color.green.frame(width: cgfWidth)
            } else {
                Color.red.frame(width: cgfWidth)
            }
            
            VStack(alignment: .leading) {
                Text("\(arg.sentence)\n")
                
                HStack(alignment: .center) {
                    Text("Sentiment:").bold()
                    Text("\(arg.sentiment == 0 ? "Neutral" : arg.sentiment > 0 ? "Positive" : "Negative")")
                    
                    Divider().frame(height: cgfHeight)
                    Text("Similarity:").bold()
                    Text("\(arg.distance! < 0.5 ? "High" : arg.distance! < 0.8 ? "Medium" : "Low") (\(Int((1 - arg.distance!) * 100))%)")
                    
                    Divider().frame(height: cgfHeight)
                    Text("Supporting:").bold()
                    Text("\(arg.supporting! ? "Yes" : "No")")
                }
            }
            Spacer()
        }
    }
}
