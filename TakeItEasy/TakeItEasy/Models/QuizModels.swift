//
//  QuizModels.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-14.
//

import Foundation
class Quiz{
    var quizId : Int?
    var quizName : String?
    var questions : [Question]?
    var totalScore : Double {
        var total = 0.0
        for item in questions!{
            total += item.score!
        }
        return total
    }

   init(id : Int, name : String, quizQuestions : [Question]){
       quizId = id
       quizName = name
       questions = quizQuestions
   }

}

class Question{
    var questionid : Int?
    var questionName : String?
    var answers : [Answer]?
    var score : Double?
   var quizId : Int?

   init(id : Int, name : String, qScore : Double, qId : Int, questionAns : [Answer]){
       questionid = id
       questionName = name
       score = qScore
       quizId = qId
       answers = questionAns
   }
}

class Answer{
    var answerId : Int?
    var answerName : String?
    var isCorrect : Bool?
   var questionId : Int?

   init(id : Int, name: String, isCor : Bool, qId : Int){
       answerId = id
       answerName = name
       isCorrect = isCor
       questionId = qId
   }
}

class UserResult{
   var resultId : Int?
   var username : String?
   var quizId : Int?
   var userScore : Double?

   init(rId : Int, user : String, qId : Int, score : Double){
       resultId = rId
       username = user
       quizId = qId
       userScore = score
   }
}
