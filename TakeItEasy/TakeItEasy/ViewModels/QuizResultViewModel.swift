//
//  QuizResultViewModel.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-16.
//

import Foundation
class QuizResultViewModel{
    private var result : UserResult
    private var passed = false
    var questionNames = [String]()
    var correctAnswers = [String]()
    init(res : UserResult){
        result = res
        if(result.userScore! >= 80.0){
            passed = true
        }
        let quesArr = QuizDBHelper.dbHelper.getQuizQuestions(quizId: result.quizId!)
        for question in quesArr {
            questionNames.append(question.questionName!)
            correctAnswers.append(QuizDBHelper.dbHelper.getSingleCorrectAnswerName(questionId: question.questionid!))
        }
    }
    
    func didUserPass() -> Bool{
        return passed
    }
    
    func getScore() -> Double{
        return result.userScore!
    }
    
    func getArrayCount() -> Int{
        return questionNames.count
    }
    
    func getCode() -> String{
        if(result.userScore == 0){
            return "Better luck next time"
        }
        else{
            return randomTenCode()
        }
    }
    
    private func randomTenCode() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<10).map{ _ in letters.randomElement()! })
    }
    
}
