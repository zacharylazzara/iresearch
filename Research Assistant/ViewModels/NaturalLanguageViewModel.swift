//
//  NaturalLanguageViewModel.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-08-02.
//

import Foundation
import NaturalLanguage
//import CreateML

class NaturalLanguageViewModel {
    private let language:NLLanguage
    
    // TODO: make these private later
    var doc1: String
    var doc2: String
//    var sents1: Array<String> = []
//    var sents2: Array<String> = []
    
    private var sentDic: Dictionary<String, Array<String>>?
    // TODO: we might want the dictionary to contain more than just an array; it needs an array of tuples which includes
    // info on similarity (or distance), as well as sentiment. We may want other data in this dictionary such as keywords.
    // We may want to make a class or an object of some sort to store this data (remember the Pokemon thing we did; there was
    // a specific data type that was very powerful for these type of associations that don't need functions built in; a data class or something).
    init(doc1: String, doc2: String, language: NLLanguage = .english) {
        self.language = language
        self.doc1 = doc1
        self.doc2 = doc2
//        sents1 = tokenize(text: doc1)
//        sents2 = tokenize(text: doc2)
    }
    
    func tokenize(text: String, unit: NLTokenUnit = .sentence) -> Array<String> {
        let tokenizer = NLTokenizer(unit: unit)
        tokenizer.string = text
        
        var sentence: Array<String> = []

        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
            sentence.append(String(text[tokenRange])) // TODO: determine if this is the right way to get the value out of this enumeration
            return true
        }
        
        return sentence
    }
    
    func sentimentAnalysis(for text: String, unit: NLTokenUnit = .sentence) -> String {
        let tagger = NLTagger(tagSchemes: [.tokenType, .sentimentScore])
        tagger.string = text
        
        var senScore:String?
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .paragraph,
                             scheme: .sentimentScore, options: []) { sentiment, _ in
            
            if let sentimentScore = sentiment {
                senScore = sentimentScore.rawValue
            }
            
            return true
        }
        
        return senScore!
    }
    
    func sentenceSimialrity(sent1: String, sent2: String) -> String {
        var distance: NLDistance?
        if let sentenceEmbedding = NLEmbedding.sentenceEmbedding(for: language) {
//            if let vector = sentenceEmbedding.vector(for: sent1) {
//                print (vector)
//            }
            distance = sentenceEmbedding.distance(between: sent1, and: sent2)
        }
        return distance!.description
    }
//    // TODO: we use the above function to determine how similar the sentences are; we can now start implementing what we have in the Python experimental code
//
//    // First step is to tokenize the input text into sentences
//
//
//    // doc1 and 2 will be the text extracted from a PDF or other document; we will deal only in the actual text itself here and not the document at all
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//    // We'll compare sentiment between the papers to determine if references are in agreement or not.
//    // By default we compare sentences, but it may be useful to compare paragraphs at times too
//    func sentimentAnalysis(for text: String, unit: NLTokenUnit = .sentence) -> Double {
//        let tagger = NLTagger(tagSchemes: [.sentimentScore])
//
//        let string = text
//        tagger.string = string
//
//        let (sentiment, _) = tagger.tag(at: string.startIndex, unit: unit, scheme: .sentimentScore)
//        let value = sentiment?.rawValue ?? ""
//
//        return (value as NSString).doubleValue
//    }
//
//    func compareSentiment(text1: String, text2: String) -> Double {
//        // TODO: we should verify that our sentence is no more than a sentence; if longer than a sentence we will use paragraph mode instead!
//        // We should return the difference
//
//        // TODO: perhaps instead of difference, we should return whether or not the two texts are in agreement (we must confirm they
//        // mean the same thing, and then we must see if their sentiment is equivalent)
//
//        let difference = sentimentAnalysis(for: text1) - sentimentAnalysis(for: text2)
//        return difference
//    }
//
//    func getNeighbours(text: String) {
//        // TODO: we want to return a dictionary in which each word in the sentence is an array of the neighbours of that word
//
//        var neighbours = [String:Array]
//        let embedding = NLEmbedding.wordEmbedding(for: .english)
//
//        let tokenizer = NLTokenizer(unit: .word)
//        tokenizer.string = text
//
//        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
//            word = text[tokenRange]
//            neighbours[word] = embedding?.neighbors(for: embedding?.vector(for: word) ?? [], maximumCount: 10) ?? []
//        }
//        // TODO: we need to make sure the dictionary keeps the correct order; failing that, we should make our key be a tuple including the word and the index
//        return neighbours
//
//        /* TODO:
//         We should use this whenever possible, as it will give us the most accurate representation of the meaning.
//         However, I believe sentence embedding does this for us, so we won't need to do this on our own? In which case we should focus on sentence embedding instead.
//
//         */
//    }
//
//
//    // This will need to search through our library and get text from relevant PDFs to compare to thesis text
//
//    /* Things we need
//     - Reference text (comes from PDF; let another system extract the text and pass it here)
//     - Thesis text (comes from a number of sources; again we'll just take the text itself)
//     - Natural Language processing library so we can compare the texts
//
//     We'll take in the full text then break it up into sentences within this view model.
//
//     */
//
//    func tokenizeCorpus() -> Dictionary<Unit, String> {
//
//    }
//
//    /*
//     Using CreateML we can create custom embeddings; we'll probably want to do this for each PDF in our library.
//
//     let embedding = try MLWordEmbedding(dictionary: sentenceVectors)
//     try embedding.write(to: URL(fileURLWithPath: "/tmp/Verse.mlmodel"))
//
//     TODO: we might want to use clustering to make groups based on things close together in meaning
//     No need to remove stop words with clusering as these models have already seen all that
//     */
//
//
//
//
//    // adapted from WWDC2020 video
//    func relevantPassage(for thesisPassage: String) -> String? {
//        guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else {
//            return nil
//        }
//        guard let queryVector = embedding.vector(for: thesisPassage) else {
//            return nil
//        }
//
//        var referenceKey: String? = nil
//        var referenceDistance = 2.0
//
//        for (key, vectors) in self.faqEmbeddings {
//            for (vector) in vectors {
//                let distance = self.cosineDistance(vector, queryVector)
//                if (distance < answerDistance) {
//                    referenceDistance = distance
//                    referenceKey = key
//                }
//            }
//        }
//
//        return referenceKey
//    }
//
//    // From WWDC2020 video
////    func answerKey(for string: String) -> String? {
////        guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else {
////            return nil
////        }
////        guard let queryVector = embedding.vector(for: string) else {
////            return nil
////        }
////
////        var answerKey: String? = nil
////        var answerDistance = 2.0
////
////        for (key, vectors) in self.faqEmbeddings {
////            for (vector) in vectors {
////                let distance = self.cosineDistance(vector, queryVector)
////                if (distance < answerDistance) {
////                    answerDistance = distance
////                    answerKey = key
////                }
////            }
////        }
////
////        return answerKey
////    }
//
//
//
//
//
//
//
//
//    func compareCorpus(thesisCorpus: String, referenceCorpus: String) -> <#return type#> {
//        /*
//         We should return a dictionary that associates thesis sentences with the most relevant reference sentences
//         */
//
//        //tSentences
//
//        // Thesis
////        tDoc: String
////        tSent: String
////        tWord: String
////
////        // Reference
////        rDoc: String
////        rSent: String
////        rWord: String
//
//
//        let tokenizer = NLTokenizer(unit: .sentence)
//        tokenizer.string = thesisCorpus
//
//        tokenizer.enumerateTokens(in: thesisCorpus.startIndex..<thesisCorpus.endIndex) { tokenRange, _ in
//            print(thesisCorpus[tokenRange])
//            return true
//        }
//        // TODO: Watch video at https://developer.apple.com/videos/play/wwdc2020/10657/
//        // TODO: We'll want to use dynamic word embeddings, this will improve accuracy a lot
//        // Also look into sentence embedding
//        // We might not want to tokenize on words; just focus on tokenizing on sentences, as we can cluster sentences which are similar using sentence embedding
//
//
//
//        // Sentence Embedding
//        if let embedding = NLEmbedding.sentenceEmbedding(for: .english) { // TODO: determine language from reference and thesis
//            let sentence = "This is a sentence." // Thesis sentence can go here
//
//            if let vector = NLEmbedding.sentenceEmbedding.vector(for: sentence) {
//                print(vector)
//            }
//
//            let dist = NLEmbedding.sentenceEmbedding.distance(between:sentence, and: "This is another sentence.") // Reference sentence can go here
//            print(dist)
//        }
//
//        /*
//         The distance between these sentences will tell us how similar or dissimilar they are.
//         This would be perfect for my goals, as it should help us determine if a sentence from the reference is relevant to the thesis or not.
//
//         Note that sentence embeddings have no nearest neighbour API, but there may be ways to implement such a thing ourself?
//
//         Info on this is around the 18 minute mark in the video
//         */
//
//
//
//
//
//
//
//        // We want to find the overall meaning of the entire document, each paragraph, and each sentence
//        /* General idea
//
//         Break thesis and reference into document, paragraphs, and sentences.
//         Determine the meaning of each of these.
//         Compare the meaning to each other (thesis meaning compared with reference meaning)
//         Flag elements with similar meanings. Put a similarity score for each (order by most similar first, and drop anything less similar than our threshold)
//
//         */
//
//
//
//    }
    
    
    
}
