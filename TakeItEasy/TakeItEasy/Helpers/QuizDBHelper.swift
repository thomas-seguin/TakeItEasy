//
//  QuizDBHelper.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-14.
//

import Foundation
import SQLite3
class QuizDBHelper{
  // MARK: Variables
      static var dbHelper = QuizDBHelper()
      var dbPointer : OpaquePointer?
      var quizzes = [Quiz]()
      var questions = [Question]()
      var answers = [Answer]()
      var results = [UserResult]()
  // MARK: Create Db and tables
    //Creates and opens DB (only opens DB if its already created)
      func createDB(){
          let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("QuizDB.sqlite")
 
          if sqlite3_open(filePath.path, &dbPointer) != SQLITE_OK{
              print("Cannot Open Database")
          }
          else{ print("Success opening db")}
      }
 
      func createQuizTable(){
          if sqlite3_exec(dbPointer, "create table if not exists Quizzes (quizId integer primary key autoincrement, quizName text)", nil, nil, nil) !=  SQLITE_OK{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating Quiz table", err)
          }
          else{
              print("Succes creating Quiz Table")
          }
      }
 
      func createQuestionTable(){
          if sqlite3_exec(dbPointer, "create table if not exists Questions (questionId integer primary key autoincrement, questionName text, score double, quizId int)", nil, nil, nil) !=  SQLITE_OK{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating question table", err)
          }
          else{
              print("Succes creating Question Table")
          }
      }
 
      func createAnswerTable(){
          if sqlite3_exec(dbPointer, "create table if not exists Answers (answerId integer primary key autoincrement, answerName text, isCorrect int, questionId int)", nil, nil, nil) !=  SQLITE_OK{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating answer table", err)
          }
          else{
              print("Succes creating Answer Table")
          }
      }
 
      func createResultTable(){
          if sqlite3_exec(dbPointer, "create table if not exists Results (resultId integer primary key autoincrement, username text, quizId int, resultScore double)", nil, nil, nil) !=  SQLITE_OK{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating result table", err)
          }
          else{
              print("Succes creating Result Table")
          }
      }
    // This will not do anything if table already exist
      func createTables(){
          createQuizTable()
          createQuestionTable()
          createAnswerTable()
          createResultTable()
      }
  //MARK: QuizFunctions
 
      func insertQuiz(quizName : NSString){
          var stmt : OpaquePointer?
          let query = "insert into Quizzes (quizName) values (?)"
          if sqlite3_prepare(dbPointer, query, -1, &stmt, nil) == SQLITE_OK{
              if sqlite3_bind_text(stmt, 1, quizName.utf8String, -1, nil) == SQLITE_OK{
                  if sqlite3_step(stmt) == SQLITE_DONE{
                      print("Quiz inserted")
                  }
                  else{
                      let err = String(cString: sqlite3_errmsg(dbPointer))
                      print("Error in inserting quiz", err)
                  }
 
              }
              else{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in binding quiz name", err)
              }
          }
          else{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating insert quiz query", err)
          }
      }
 
      func getallQuiz() -> [Quiz]{
          quizzes.removeAll()
          var stmt : OpaquePointer?
          let query = "Select * from Quizzes"
          if sqlite3_prepare(dbPointer, query, -1, &stmt, nil) != SQLITE_OK{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating getAllQuiz query", err)
              return quizzes
          }
          while(sqlite3_step(stmt) == SQLITE_ROW){
              let id = sqlite3_column_int(stmt, 0)
              let name = String(cString: sqlite3_column_text(stmt, 1))
 
              quizzes.append(Quiz(id: Int(id), name: name, quizQuestions: getQuizQuestions(quizId: Int(id))))
          }
 
          return quizzes
      }
 
  //MARK: Question Functions
      func insertQuestion(questionName : NSString, questionsScore : Double, quizId : Int){
          var stmt : OpaquePointer?
          let query = "insert into Questions (questionName, score, quizId) values (?, ?, ?)"
          if sqlite3_prepare(dbPointer, query, -1, &stmt, nil) == SQLITE_OK{
              //bind parameters
              if sqlite3_bind_text(stmt, 1, questionName.utf8String, -1, nil) != SQLITE_OK{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in binding question name", err)
              }
              if sqlite3_bind_double(stmt, 2, questionsScore) != SQLITE_OK{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in binding question score", err)
              }
              if sqlite3_bind_int(stmt, 3, Int32(quizId)) != SQLITE_OK{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in binding quiz id", err)
              }
 
              //insert
              if sqlite3_step(stmt) == SQLITE_DONE{
                  print("Question inserted")
              }
              else{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in inserting question", err)
              }
          }
          else{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating insert question query", err)
          }
      }
 
 
 
      func getQuizQuestions(quizId : Int) -> [Question]{
          questions.removeAll()
          var stmt : OpaquePointer?
          let query = "Select * from Questions where quizId = \(quizId)"
          if sqlite3_prepare(dbPointer, query, -1, &stmt, nil) != SQLITE_OK{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating getQuizQuestion query", err)
              return questions
          }
          while(sqlite3_step(stmt) == SQLITE_ROW){
              let id = sqlite3_column_int(stmt, 0)
              let name = String(cString: sqlite3_column_text(stmt, 1))
              let score = sqlite3_column_double(stmt, 2)
              let qId = sqlite3_column_int(stmt, 3)
              questions.append(Question(id: Int(id), name: name, qScore: score, qId: Int(qId), questionAns: getQuestionAnswers(questionId: Int(id))))
          }
 
          return questions
      }
    
    //COMPLETELY DELETES TABLE
    func dropQuestionsTable(){
        if sqlite3_exec(dbPointer, "DROP table if exists Questions", nil, nil, nil) !=  SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(dbPointer))
            print("Error in dropping Questions table", err)
        }
        else{
            print("Succes dropping Quesitons Table")
        }
    }
 
  //MARK: Answer Functions
      func insertAnswer(answerName : NSString, isCorrect : Int, questionId : Int){
          var stmt : OpaquePointer?
          let query = "insert into Answers (answerName, isCorrect, questionId) values (?, ?, ?)"
          if sqlite3_prepare(dbPointer, query, -1, &stmt, nil) == SQLITE_OK{
              //bind parameters
              if sqlite3_bind_text(stmt, 1, answerName.utf8String, -1, nil) != SQLITE_OK{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in binding answer name", err)
              }
              if sqlite3_bind_int(stmt, 2, Int32(isCorrect)) != SQLITE_OK{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in binding isCorrect value", err)
              }
              if sqlite3_bind_int(stmt, 3, Int32(questionId)) != SQLITE_OK{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in binding questionId", err)
              }
 
              //insert
              if sqlite3_step(stmt) == SQLITE_DONE{
                  print("Answer Inserted")
              }
              else{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in inserting answer", err)
              }
          }
          else{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating insert answer query", err)
          }
      }
 
      func getQuestionAnswers(questionId : Int) -> [Answer]{
          answers.removeAll()
          var stmt : OpaquePointer?
          let query = "Select * from Answers where questionId = \(questionId)"
          if sqlite3_prepare(dbPointer, query, -1, &stmt, nil) != SQLITE_OK{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating getquestionanswers query", err)
              return answers
          }
          while(sqlite3_step(stmt) == SQLITE_ROW){
              let id = sqlite3_column_int(stmt, 0)
              let name = String(cString: sqlite3_column_text(stmt, 1))
              var isCor = false
              if sqlite3_column_int(stmt, 2) == 1{
                  isCor = true
              }
              let qId = sqlite3_column_int(stmt, 3)
              answers.append(Answer(id: Int(id), name: name, isCor: isCor, qId: Int(qId)))
          }
          return answers
      }
    //COMPLETELY DELETES TABLE
    func dropAnswersTable(){
        if sqlite3_exec(dbPointer, "DROP table if exists Answers", nil, nil, nil) !=  SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(dbPointer))
            print("Error in dropping answer table", err)
        }
        else{
            print("Succes dropping Answer Table")
        }
    }
    
  //MARK: Results Functions
      //call when user finished a test to save result
      func insertResult(username : NSString, quizId : Int, score : Double){
          var stmt : OpaquePointer?
          let query = "insert into Results (username, quizId, resultScore) values (?, ?, ?)"
          if sqlite3_prepare(dbPointer, query, -1, &stmt, nil) == SQLITE_OK{
              //bind parameters
              if sqlite3_bind_text(stmt, 1, username.utf8String, -1, nil) != SQLITE_OK{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in binding username", err)
              }
              if sqlite3_bind_int(stmt, 2, Int32(quizId)) != SQLITE_OK{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in binding quizID", err)
              }
              if sqlite3_bind_double(stmt, 3, score) != SQLITE_OK{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in binding result score", err)
              }
 
              //insert
              if sqlite3_step(stmt) == SQLITE_DONE{
                  print("Result Inserted")
              }
              else{
                  let err = String(cString: sqlite3_errmsg(dbPointer))
                  print("Error in inserting result", err)
              }
          }
          else{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating insert result query", err)
          }
      }
 
      func getAllUserResults(username : NSString) -> [UserResult]{
          results.removeAll()
          var stmt : OpaquePointer?
          let query = "Select * from Results where username = \(username)"
          if sqlite3_prepare(dbPointer, query, -1, &stmt, nil) != SQLITE_OK{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating getALLUserResults query", err)
              return results
          }
          while(sqlite3_step(stmt) == SQLITE_ROW){
              let rId = sqlite3_column_int(stmt, 0)
              let user = String(cString: sqlite3_column_text(stmt, 1))
              let qId = sqlite3_column_int(stmt, 2)
              let score = sqlite3_column_double(stmt, 3)
              results.append(UserResult(rId: Int(rId), user: user, qId: Int(qId), score: score))
 
          }
          return results
      }
 
      func haveUserdoneQuiz(username : NSString, qId : Int) -> Bool{
          var stmt : OpaquePointer?
          let query = "Select * from Results where username = \(username) AND quizId = \(qId)"
          if sqlite3_prepare(dbPointer, query, -1, &stmt, nil) != SQLITE_OK{
              let err = String(cString: sqlite3_errmsg(dbPointer))
              print("Error in creating getALLUserResults query", err)
              return true
          }
          var resultCount = 0
          while(sqlite3_step(stmt) == SQLITE_ROW){
              resultCount  = 1
          }
          if(resultCount == 0)
          {
              return false
          }
          else{
              return true
          }
      }
  }

