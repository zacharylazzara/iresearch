//
//  Argument.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-08-03.
//

import Foundation

public class Argument: CustomStringConvertible, Hashable {
    public static func == (lhs: Argument, rhs: Argument) -> Bool {
        return lhs.sentence == rhs.sentence
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sentence)
    }
    
    // TODO: determine if this should be in its own file or not (I'm not sure what the best practice here is)
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
    
    public var info: String {
        if distance == nil || supporting == nil {
            return "\(sentence)\n\nSentiment: \(sentiment == 0 ? "Neutral" : sentiment > 0 ? "Positive" : "Negative")"
        } else {
            return "\(sentence)\n\nSentiment: \(sentiment == 0 ? "Neutral" : sentiment > 0 ? "Positive" : "Negative")\nRelevance: \(distance! < 0.5 ? "High" : distance! < 1 ? "Medium" : "Low")\nSupporting: \(supporting! ? "Yes" : "No")"
        }
    }
    // TODO: We'll need to provide page number and perhaps sentence number too at some point, so we should figure out how to add that into our argument data.
}
