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
    
    func submitQuizResult() -> Int{
        
        let userScore = (currentScore/totalScore) * 100
        print(userScore)
        if(QuizDBHelper.dbHelper.haveUserdoneQuiz(user: currentUsername, qId: quiz.quizId!)){
            guard let rId = QuizDBHelper.dbHelper.getSingleResult(username: currentUsername, qId: quiz.quizId!).resultId else { return 0}
            QuizDBHelper.dbHelper.updateQuizResult(id: rId, score: userScore)
            return rId
        }
        else{
            QuizDBHelper.dbHelper.insertResult(username: currentUsername, quizId: quiz.quizId!, score: userScore)
            guard let rId = QuizDBHelper.dbHelper.getSingleResult(username: currentUsername, qId: quiz.quizId!).resultId else { return 0}
            return rId
        }
    }
}
