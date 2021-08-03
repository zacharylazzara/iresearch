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

struct AutoLiteratureReviewView: View {
    @State private var link: String = "" // TODO: download from link somehow
//    private var nlViewModel = NaturalLanguageViewModel(doc1: "", doc2: "")
    
    /* TODO:
     We're gonna want to utilize the share menu so we can easily send documents to the app; perhaps we shouldn't even offer the link download option under Import?
     */
    
    // TODO: change this to be the auto-literature review system
    
    var body: some View {
        VStack(alignment: .leading) {
            // TODO: we should use a viewmodel to search the library for supporting papers
            // TODO: controls to upload thesis here
            Button(action: search) {
                Image(systemName: "highlighter")
                Text("Begin Auto-Literature Review")
            }
            
        }
        .navigationTitle("Auto-Literature Review")
        .onAppear() {
            /* TODO: Remove all this temporary code
             
             For now I'll be testing the functionality of the natural language view model by testing it here.
            */
            
            // From: DOI 10.1007/s11023-014-9352-8
            let doc1 = "If a brain is uploaded into a computer, will consciousness continue in digital form or will it end forever when the brain is destroyed? Philosophers have long debated such dilemmas and classify them as questions about personal identity. There are currently three main theories of personal identity: biological, psycho- logical, and closest continuer theories. None of these theories can successfully address the questions posed by the possibility of uploading. I will argue that uploading requires us to adopt a new theory of identity, psychological branching identity. Psychological branching identity states that consciousness will continue as long as there is continuity in psychological structure. What differentiates this from psychological identity is that it allows identity to continue in multiple selves. According to branching identity, continuity of consciousness will continue in both the original brain and the upload after nondestructive uploading. Branching identity can also resolve long standing questions about split-brain syndrome and can provide clear predictions about identity in even the most difficult cases imagined by philosophers."
            
            
            // From: http://dx.doi.org/10.1016/j.neunet.2016.11.003
            let doc2 = "The hard problem of consciousness is the problem of explaining how we experience qualia or phenome- nal experiences, such as seeing, hearing, and feeling, and knowing what they are. To solve this problem, a theory of consciousness needs to link brain to mind by modeling how emergent properties of several brain mechanisms interacting together embody detailed properties of individual conscious psychologi- cal experiences. This article summarizes evidence that Adaptive Resonance Theory, or ART, accomplishes this goal. ART is a cognitive and neural theory of how advanced brains autonomously learn to attend, rec- ognize, and predict objects and events in a changing world. ART has predicted that ‘‘all conscious states are resonant states’’ as part of its specification of mechanistic links between processes of consciousness, learning, expectation, attention, resonance, and synchrony. It hereby provides functional and mechanistic explanations of data ranging from individual spikes and their synchronization to the dynamics of con- scious perceptual, cognitive, and cognitive–emotional experiences. ART has reached sufficient maturity to begin classifying the brain resonances that support conscious experiences of seeing, hearing, feeling, and knowing. Psychological and neurobiological data in both normal individuals and clinical patients are clarified by this classification. This analysis also explains why not all resonances become conscious, and why not all brain dynamics are resonant. The global organization of the brain into computationally com- plementary cortical processing streams (complementary computing), and the organization of the cerebral cortex into characteristic layers of cells (laminar computing), figure prominently in these explanations of conscious and unconscious processes. Alternative models of consciousness are also discussed."
            
            // TODO: when we see "- " remove it and concatonate, since its used for the miserable kind of word wrapping that makes things harder to read
            let nlViewModel = NaturalLanguageViewModel(doc1: doc1, doc2: doc2)
            
            let sents1 = nlViewModel.tokenize(text: doc1)
            let sents2 = nlViewModel.tokenize(text: doc2)
            
//            print("\nNLP Testing:")
//            let sep = "-----------------------------------"
//            sents1.forEach { sent1 in
//                print("\(sep)\n[Sentiment: \(nlViewModel.sentimentAnalysis(for: sent1))]\n\(sent1)\n")
//                sents2.forEach { sent2 in
//                    print("\t[Sentiment: \(nlViewModel.sentimentAnalysis(for: sent2)), Distance: \(nlViewModel.sentenceDistance(sent1: sent1, sent2: sent2))]\n\t\(sent2)\n")
//                }
//            }
            
            // TODO: Now we should be able to start making dictionaries of similarity and use the sentiment to roughly determine level of agreement
            // This may be of value: https://www.slideshare.net/vicknickkgp/analyzing-arguments-during-a-debate-using-natural-language-processing-in-python
            
            print(nlViewModel.argumentAnalysis(for: doc1, against: doc2))
            
        }
        
        Spacer()
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
