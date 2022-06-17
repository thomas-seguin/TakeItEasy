//
//  QuestionaireViewModel.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-16.
//

import Foundation
class QuestionaireViewModel{
    var quiz : Quiz
    var questionArr : [Question]
    var totalScore = 5.0
    var currentScore = 0.0
    var currentUsername : NSString
    init(q : Quiz){
        quiz = q
        questionArr = quiz.questions!
        totalScore = quiz.totalScore
        currentUsername = UserSingleton.userData.currentUsername as NSString
    }
    
    func getAnswers(currentQues : Int) -> [Answer]{
        
        return questionArr[currentQues].answers!
    }
    func getQuestionName(currentQues : Int) -> String{
        
        return questionArr[currentQues].questionName!
    }
    
    func submitAnswer(ans : Answer, currentQues : Int){
        if(ans.isCorrect!){
            currentScore += questionArr[currentQues].score!
            
        }
        print(currentScore, "/", totalScore)
        
    }
    
    func submitAndGetQuizResult() -> UserResult{
        
        let userScore = (currentScore/totalScore) * 100
        print(userScore)
        QuizDBHelper.dbHelper.insertResult(username: currentUsername, quizId: quiz.quizId!, score: userScore)
        return QuizDBHelper.dbHelper.getSingleResult(username: currentUsername, qId: quiz.quizId!)
    }
}
