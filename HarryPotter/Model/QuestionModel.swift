//
//  QuestionModel.swift
//  HarryPotter
//
//  Created by Aman Giri on 2024-05-07.
//

import Foundation

struct QuestionModel: Codable {
    let id: Int
    let question: String
    var answer: [String: Bool] = [:]
    let book: Int
    let hint: String
    
    enum QuestionKeys: String, CodingKey {
        case id
        case question
        case answer
        case book
        case wrong
        case hint
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: QuestionKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.question = try container.decode(String.self, forKey: .question)
        self.book = try container.decode(Int.self, forKey: .book)
        self.hint = try container.decode(String.self, forKey: .hint)
        
        let correctAnswer = try container.decode(String.self, forKey: .answer)
        self.answer[correctAnswer] = true
        let wrongAnswer = try container.decode([String].self, forKey: .wrong)
        for answer in wrongAnswer {
            self.answer[answer] = false
        }
    }
}
