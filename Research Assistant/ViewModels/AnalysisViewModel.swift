//
//  NaturalLanguageViewModel.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-08-02.
//

import Foundation
import NaturalLanguage

class AnalysisViewModel: ObservableObject {
    private let language:NLLanguage
    private let artifacts: Array<(String, String)>
    private let stopwords: Array<String>
    
    @Published public var progress: Double
    @Published public var percent: Int
    @Published public var sentCapacity: Int
    @Published public var compareProgress: Int
    @Published public var args: Array<Argument>
    @Published public var keywordStr: String
    @Published public var analysisStarted: Bool
    
    public var keywordDictionary: Dictionary<String, Int> = [:]
    
    init(language: NLLanguage = .english) {
        self.language = language
        self.progress = 0.0
        self.percent = 0
        self.sentCapacity = 0
        self.compareProgress = 0
        self.args = []
        self.keywordStr = "keyword (occurances)"
        self.analysisStarted = false
        
        self.artifacts = [("- ", "")] // Artifacts should be replaced by the associated feature; i.e., (artififact, replacement)
        self.stopwords = ["i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", "yourself", "yourselves", "he", "him", "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself", "they", "them", "their", "theirs", "themselves", "what", "which", "who", "whom", "this", "that", "these", "those", "am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "a", "an", "the", "and", "but", "if", "or", "because", "as", "until", "while", "of", "at", "by", "for", "with", "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", "down", "in", "out", "on", "off", "over", "under", "again", "further", "then", "once", "here", "there", "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very", "s", "t", "can", "will", "just", "don", "should", "now", "per", "www", "com"]
    }
    
    private func sanitize(text: String) -> String {
        var sText: String = text
        artifacts.forEach { artifact in
            sText = sText.replacingOccurrences(of: artifact.0, with: artifact.1)
        }
        return sText
    }
    
    func nearestArgs(for args: Array<Argument>, distanceThreshold: Double = 0.8) throws -> Array<Argument> {
        if distanceThreshold < 0 {
            throw AnalysisError.runtimeError("Distance threshold (\(distanceThreshold)) is out of range [0, infinity]") // TODO: verify distance range is indeed [0, infinity]
        }
        
        var nearestArgs: Array<Argument> = []
        args.forEach { arg in
            let nearestArg = arg.args.max(by: { c, _ in
                return c.distance! < distanceThreshold // TODO: redo this part, and follow from https://stackoverflow.com/questions/56916160/find-nearest-smaller-number-in-array
            })
            
            arg.args = []
            if nearestArg != nil {
                arg.args.append(nearestArg!)
            }
            
            nearestArgs.append(arg)
        }
        return nearestArgs
    }
    
    func analyse(for doc1: String, from doc2: String, nKeywords: Int = 50, depth: Int = 0, distanceThreshold: Double = 0.8) throws {
        if doc1.isEmpty || doc2.isEmpty {
            throw AnalysisError.runtimeError("Empty thesis or reference document(s)")
        }
        
        if depth < 0 {
            throw AnalysisError.runtimeError("Depth (\(depth)) is out of range [0, infinity]")
        }
        
        analysisStarted = true
        var sents1 = tokenize(text: doc1)
        var sents2 = tokenize(text: doc2)
        let maxDepth: Int
        
        sents1.removeAll { sent in
            stopwords.contains(sent.lowercased()) || Int(sent) != nil || sent.count < 3
        }
        
        sents2.removeAll { sent in
            stopwords.contains(sent.lowercased()) || Int(sent) != nil || sent.count < 3
        }
        
        switch depth {
        case 0:
            maxDepth = sents2.count
        default:
            if depth < sents2.count { // We'll want a random sample from sents2 if we have a depth constraint so that searches can go beyond the first few sentences
                maxDepth = depth
                
                var sents2Randomized: Array<String> = []
                sents2Randomized.reserveCapacity(maxDepth)
                
                (0..<maxDepth).forEach { _ in
                    sents2Randomized.append(sents2[Int.random(in: sents2.indices)])
                }
                
                sents2 = sents2Randomized
            } else {
                maxDepth = sents2.count
            }
        }
        
        sentCapacity = sents1.count * maxDepth
        args.reserveCapacity(sentCapacity)
        
        compareProgress = 0 // TODO: for some reason we can exceed the progress expected?
        percent = 0
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "dev.lazzara.iresearch") // TODO: rename app to Róka at some point, and perhaps make this label a global variable
        
        let workItem = DispatchWorkItem { [self] in
            sents1.forEach { sent1 in
                queue.async(group: group) {
                    var currentDepth: Int = 0
                    
                    print("Analyzing Sentence: \(sent1)")
                    
                    DispatchQueue.main.async {
                        keywords(for: sent1, top: nKeywords)
                    }
                    
                    let sentiment1 = sentiment(for: sent1)
                    let analysis = Argument(sentence: sent1, sentiment: sentiment1)
                    
                    for sent2 in sents2 {
                        currentDepth += 1
                        
                        DispatchQueue.main.async {
                            keywords(for: sent2, top: nKeywords)
                        }
                        
                        let sentiment2 = sentiment(for: sent2)
                        let distance = distance(between: sent1, and: sent2)
                        let sentiment = sentiment1 * sentiment2
                        
                        if distance < distanceThreshold {
                            analysis.args.append(Argument(sentence: sent2, sentiment: sentiment2, distance: distance, supporting: sentiment >= 0))
                        }
                        
                        DispatchQueue.main.async {
                            compareProgress += 1
                            progress = Double(compareProgress) / Double(sentCapacity)
                            percent = Int(progress * 100)
                        }
                        
                        print("\rAnalysis Progress: \(percent)% (\(compareProgress)/\(sentCapacity)), Depth: \(currentDepth)/\(maxDepth)")
                        
                        if currentDepth >= maxDepth {
                            print("Depth (\(maxDepth)) reached!")
                            break
                        }
                    }
                    
                    DispatchQueue.main.async {
                        args.append(analysis)
                    }
                    
                    print("\nFinished Analyzing Sentence: \(sent1)\n")
                }
            }
        }
        
        DispatchQueue.global().async(group: group, execute: workItem)
        
        group.notify(queue: .main) { [self] in
            print("Document Analysis Complete:\n\(args)")
        }
        
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
    
    func keywords(for doc: String, top n: Int = 10) {
        let sDoc = sanitize(text: doc)
        var words = tokenize(text: sDoc, by: .word)
        
        words.removeAll { word in
            stopwords.contains(word.lowercased()) || Int(word) != nil || word.count < 3
        }
        
        let freqDic = words.reduce(into: [:]) { $0[$1.lowercased(), default: 0] += 1 } // From: https://stackoverflow.com/a/30545629/7653788
        
        freqDic.forEach { pair in
            if keywordDictionary[pair.key] != nil {
                keywordDictionary[pair.key]! += pair.value
            } else {
                keywordDictionary[pair.key] = pair.value
            }
        }
        
        var count = 0
        
        keywordStr = ""
        keywordDictionary.sorted{ return $0.value > $1.value }.forEach { keyword in
            if count < n {
                if keywordStr.isEmpty {
                    keywordStr = "\(keyword.key) (\(keyword.value))"
                } else {
                    keywordStr = "\(keywordStr), \(keyword.key) (\(keyword.value))"
                }
            } else {
                return
            }
            count += 1
        }
    }
}
