//
//  QuizViewModel.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-15.
//

import Foundation
class QuizViewModel{
 
    var quizzes : [Quiz]
    var searchedQuizzes : [Quiz]
    init(){
//MARK: Initialize DB and Tables
        QuizDBHelper.dbHelper.createDB()
        QuizDBHelper.dbHelper.createTables()
        //This is where you call populator
//MARK: Testing
        //QuizPopulator.populator.checkingQuizTable()
        //QuizPopulator.populator.checkingQuestionsTable()
//        QuizPopulator.populator.checkingAnswersTable(testQuiz: 1)
//        QuizPopulator.populator.checkingAnswersTable(testQuiz: 2)
//        QuizPopulator.populator.checkingAnswersTable(testQuiz: 3)
//        QuizPopulator.populator.checkingAnswersTable(testQuiz: 4)
//MARK: Implementation
        
        quizzes = QuizDBHelper.dbHelper.getallQuiz()
        searchedQuizzes = quizzes
    }
    
    func getSearchedQuizzes(searchText : String) -> [Quiz]{
        if(searchText == ""){
            searchedQuizzes = quizzes
            return searchedQuizzes
        }
        else{
            searchedQuizzes.removeAll()
            for quiz in quizzes {
                if(quiz.quizName?.lowercased() == searchText.lowercased()){
                    searchedQuizzes.append(quiz)
                }
            }
            return searchedQuizzes
        }
    }
    
    
//MARK: DONT!!!
    func dontCallThis(){
        //QuizPopulator.populator.quizPopulator()
        //QuizPopulator.populator.questionPopulator()
        //QuizPopulator.populator.answerPopulator()
        
    }
}
