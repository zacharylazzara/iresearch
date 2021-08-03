//
//  NaturalLanguageViewModel.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-08-02.
//

import Foundation
import NaturalLanguage

class NaturalLanguageViewModel {
    private let language:NLLanguage
    private let stopwords = ["i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", "yourself", "yourselves", "he", "him", "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself", "they", "them", "their", "theirs", "themselves", "what", "which", "who", "whom", "this", "that", "these", "those", "am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "a", "an", "the", "and", "but", "if", "or", "because", "as", "until", "while", "of", "at", "by", "for", "with", "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", "down", "in", "out", "on", "off", "over", "under", "again", "further", "then", "once", "here", "there", "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very", "s", "t", "can", "will", "just", "don", "should", "now"]
    
    public class Argument: CustomStringConvertible { // TODO: determine if this should be in its own file or not (I'm not sure what the best practice here is)
        public let sentence: String // TODO: string should throw an exception if it's ever empty
        public let sentiment: Double // TODO: enforce range [-1.0, 1.0]; if exceeded we should throw an exception
        public let distance: Double? // TODO: distance should throw an exception if it's ever set to negative
        public let supporting: Bool?
        
        public var args: Array<Argument> = []
        
        init(sentence: String, sentiment: Double, distance: Double? = nil, supporting: Bool? = nil) {
            self.sentence = sentence
            self.sentiment = sentiment
            self.distance = distance
            self.supporting = supporting
        }
        
        public var description: String {
            return "\n\nSENTENCE: \(sentence), \nSENTIMENT: \(sentiment), \nDISTANCE: \(String(describing: distance ?? nil)), \nSUPPORTING: \(String(describing: supporting)), \nARGS: \(args)"
        }
    }
    
    init(language: NLLanguage = .english) {
        self.language = language
    }
    
    private func sanitize(text: String) -> String {
        return text.replacingOccurrences(of: "- ", with: "") // Any additional repairing/cleaning of the text should be done here
    }
    
    func citations(for doc1: String, from doc2: String, distanceThreshold: Double = 1.0, sentimentThreshold: Double = 0.3) -> Array<Argument> {
        let sents1 = tokenize(text: doc1)
        let sents2 = tokenize(text: doc2)
        
        var args: Array<Argument> = []
        
        sents1.forEach { sent1 in
            let sentiment1 = sentiment(for: sent1)
            let analysis = Argument(sentence: sent1, sentiment: sentiment1)
            sents2.forEach { sent2 in
                let sentiment2 = sentiment(for: sent2)
                let distance = distance(between: sent1, and: sent2)
                let sentimentDifference = abs(sentiment1 - sentiment2) // TODO: make sure the math makes sense for this
                
                if distance < distanceThreshold {
                    analysis.args.append(Argument(sentence: sent2, sentiment: sentiment2, distance: distance, supporting: sentimentDifference < sentimentThreshold))
                }
            }
            args.append(analysis)
        }
        
        return args
    }
    
    func tokenize(text: String, by unit: NLTokenUnit = .sentence) -> Array<String> {
        let sText = sanitize(text: text)
        
        let tokenizer = NLTokenizer(unit: unit)
        tokenizer.string = sText
        
        var sentence: Array<String> = []

        tokenizer.enumerateTokens(in: sText.startIndex..<sText.endIndex) { tokenRange, _ in
            sentence.append(String(sText[tokenRange])) // TODO: determine if this is the right way to get the value out of this enumeration
            return true
        }
        
        return sentence
    }
    
    func sentiment(for text: String, by unit: NLTokenUnit = .sentence) -> Double {
        let sText = sanitize(text: text)
        let tagger = NLTagger(tagSchemes: [.tokenType, .sentimentScore])
        tagger.string = sText
        
        var senScore: Double?
        
        tagger.enumerateTags(in: sText.startIndex..<sText.endIndex, unit: .paragraph,
                             scheme: .sentimentScore, options: []) { sentiment, _ in
            
            if let sentimentScore = sentiment {
                senScore = Double(sentimentScore.rawValue)
            }
            
            return true
        }
        
        return senScore!
    }
    
    func distance(between sent1: String, and sent2: String, distanceType: NLDistanceType = .cosine) -> Double {
        let sSent1 = sanitize(text: sent1)
        let sSent2 = sanitize(text: sent2)
        
        var distance: NLDistance?
        if let sentenceEmbedding = NLEmbedding.sentenceEmbedding(for: language) {
            distance = sentenceEmbedding.distance(between: sSent1, and: sSent2, distanceType: distanceType)
        }
        return Double(distance!.description)!
    }
    
    func keywords(for doc: String, top n: Int = 10) -> ArraySlice<(String, Int)> {
        let sDoc = sanitize(text: doc)
        var words = tokenize(text: sDoc, by: .word)
        
        words.removeAll { word in
            stopwords.contains(word.lowercased())
        }
        
        let freqDic = words.reduce(into: [:]) { $0[$1, default: 0] += 1 } // From: https://stackoverflow.com/a/30545629/7653788
        
        var freqArr: Array<(String, Int)> = []
        freqDic.sorted{ return $0.value > $1.value }.forEach { freqTup in
            freqArr.append((freqTup.key, freqTup.value))
        }
        
        return freqArr.prefix(n)
    }
}
