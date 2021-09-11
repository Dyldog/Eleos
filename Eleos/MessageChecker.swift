//
//  MessageChecker.swift
//  Eleos
//
//  Created by Dylan Elliott on 11/9/21.
//

import Foundation

struct NaughtyWord {
    let word: String // guys
    let alternative: String // people
    let reasoning: String // it makes women feel excluded because it is a gender specific term and it doesn't include them
}

enum MessageChecker {
    static let naughtyWorks: [NaughtyWord] = [
        .init(
            word: "guys",
            alternative: "people",
            reasoning: "it makes women feel excluded because it is a gender specific term and it doesn't include them"
        )
    ]
    
    static func checkMessage(_ text: String) -> NaughtyWord? {
        let messageWords = text.lowercased().components(separatedBy: " ")
        
        return Self.naughtyWorks.first { naughty in
            messageWords.contains(where: { $0 == naughty.word })
        }
    }
}
