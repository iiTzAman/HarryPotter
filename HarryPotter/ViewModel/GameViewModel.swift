//
//  GameViewModel.swift
//  HarryPotter
//
//  Created by Aman Giri on 2024-05-07.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    
    @Published var gameScore = 0
    @Published var questionScore = 5
    @Published var recentScores = [0, 0 , 0]
    let filePath: URL = FileManager().temporaryDirectory.appending(path: "SavedScores")
    
    private var allQuestions: [QuestionModel] = []
    private var filteredQuestions: [QuestionModel] = []
    private var answeredQuestions: [Int] = []
    var currentQuestion = Constants.previewQuestion
    var answers:[String] = []
    var correctAnswer: String {
        currentQuestion.answer.first(where: {$0.value == true})!.key
    }
    
    init(){
        getAllQuestions()
    }
    
    func startGame(){
        answeredQuestions = []
        gameScore = 0
        questionScore = 5
    }
    
    func filterQuestions(of books: [Int]){
        filteredQuestions = allQuestions.filter{books.contains($0.book)}
    }
    
    private func getAllQuestions(){
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json"){
            do {
                let decoder = JSONDecoder()
                let data = try Data(contentsOf: url)
                let questions = try decoder.decode([QuestionModel].self, from: data)
                allQuestions = questions
                filteredQuestions = questions
            } catch {
                print("Error getting the questions \(error)")
            }
        }
    }
    
    func nextQuestion(){
        if filteredQuestions.count == 0 {
            return
        }
        
        if answeredQuestions.count == filteredQuestions.count {
            answeredQuestions = []
        }
        
        var potentialQuestion = filteredQuestions.randomElement()!
        
        while answeredQuestions.contains(potentialQuestion.id) {
            potentialQuestion = filteredQuestions.randomElement()!
        }
        currentQuestion = potentialQuestion
        
        answers = []
        
        for answer in potentialQuestion.answer.keys {
            answers.append(answer)
        }
        
        answers.shuffle()
        questionScore = 5
    }
    
    func correct(){
        answeredQuestions.append(currentQuestion.id)
        withAnimation{
            gameScore += questionScore
        }
    }
    
    func endGame() {
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
        saveScores()
    }
    
    func saveScores(){
        do{
            let data = try JSONEncoder().encode(recentScores)
            try data.write(to: filePath)
        }
        catch {
            print("Couldn't save scores \(error)")
        }
    }
    
    func getScores(){
        do {
            let data = try Data(contentsOf: filePath)
            recentScores = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            recentScores = [0,0,0]
        }
    }
}
