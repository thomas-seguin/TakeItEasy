//
//  QuizPopulator.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-14.
//
//DON'T MESS THIS FILE!!!
import Foundation
import UIKit

class QuizPopulator{
    
    static var populator = QuizPopulator()
    
    //Testing/Checking Quiz table
    func checkingQuizTable(){
        let quizArr = QuizDBHelper.dbHelper.getallQuiz()
             for quiz in quizArr {
                 print(quiz.quizId!, quiz.quizName!, quiz.totalScore, quiz.questions!)
             }
    }
    //TEsting/Checking Question Table
    func checkingQuestionsTable(){
        let quizArr = QuizDBHelper.dbHelper.getallQuiz()
        for quiz in quizArr {
            print(quiz.quizName!)
            let quesArr = QuizDBHelper.dbHelper.getQuizQuestions(quizId: quiz.quizId!)
            for question in quesArr {
                print(question.questionid!,question.questionName!,question.score!,question.quizId!,question.answers!)
            }
        }
    }
    
    
    //Testing/Checking Answer Table
    func checkingAnswersTable(testQuiz : Int){ //testQuiz is the quizID of the quiz to be tested
        let quesArr = QuizDBHelper.dbHelper.getQuizQuestions(quizId: testQuiz)
        for question in quesArr {
            print(question.questionName!)
            let ansArr = QuizDBHelper.dbHelper.getQuestionAnswers(questionId: question.questionid!)
            for answer in ansArr {
                print(answer.answerId!, answer.questionId!, answer.answerName!, answer.isCorrect!)
            }
        }
    }

//MARK: SQLite Populators
//call to populate tables for QuizTAB PLEASE CALL ONLY ONCE EVER!!!
    func quizPopulator(){
        QuizDBHelper.dbHelper.insertQuiz(quizName: "C# Integer Data type")
        QuizDBHelper.dbHelper.insertQuiz(quizName: "C# Polymorphism")
        QuizDBHelper.dbHelper.insertQuiz(quizName: "C# Fundamentals of inheritance")
        QuizDBHelper.dbHelper.insertQuiz(quizName: "C# Interfaces Introduction")
    }
    func questionPopulator(){
        let questionaire = [["1. How many Bytes are stored by ‘Long’ Data type in C# .net?", "2. Choose .NET class name from which data type UInt is derived?", "3. Correct Declaration of Values to variables a and b?", "4. Arrange the following data type in order of increasing magnitude sbyte, short, long, int.", "5. Which data type should be more preferred for storing a simple number like 35 to improve execution speed of a program?"], ["1. The capability of an object in Csharp to take number of different forms and hence display behaviour as according is known as ___________","2. Which of the following keyword is used to change data and behavior of a base class by replacing a member of the base class with a new derived member?","3. Correct way to overload +operator?","4. Which of the following statements is correct?","5. Selecting appropriate method out of number of overloaded methods by matching arguments in terms of number, type and order and binding that selected method to object at compile time is called?"], ["1. Which procedure among the following should be used to implement a ‘Has a’ or a ‘Kind of’ relationship between two entities?","2. The number of levels of inheritance are?","3. In an inheritance chain through which of the following, the base class and its components are accessible to the derived class?","4. Select the class visibility modifiers among the following:","5. In Inheritance concept, which of the following members of base class are accessible to derived class members?"], ["1. Which statement correctly defines Interfaces in C#.NET?","2. Which of the following cannot be used to declare an interface correctly?","3. A class consists of two interfaces with each interface consisting of three methods. The class had no instance data. Which of the following indicates the correct size of object created from this class?","4. Which of the following statements correctly define about the implementation of interface?","5. Select the correct statement among the given statements"]]
        var quizId = 0
        for x in questionaire{
            quizId += 1
            print(quizId)
            for y in x{
                print(y)
                QuizDBHelper.dbHelper.insertQuestion(questionName: y as NSString, questionsScore: 1.0, quizId: quizId)
            }
        }
        
    }
    
    func answerPopulator(){
        let answerSheet1 = [["a) 8","b) 4","c) 2","d) 1"], ["a) System.Int16","b) System.UInt32","c) System.UInt64","d) System.UInt16"], ["a) int a = 32, b = 40.6","b) int a = 42; b = 40;","c) int a = 32; int b = 40; ","d) int a = b = 42;"], ["a) long < short < int < sbyte","b) sbyte < short < int < long ","c) short < sbyte < int < long","d) short < int < sbyte < long"], ["a) sbyte","b) short","c) int","d) long"]]
        let correctBool1 = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0]]
        
        let answerSheet2 = [["a) Encapsulation","b) Polymorphism","c) Abstraction","d) None of the mentioned"], ["a) Overloads","b) Overrides","c) new","d) base"], ["a) public sample operator + (sample a, sample b)","b) public abstract operator + (sample a,sample b) ","c) public static sample operator + (sample a, sample b","d) None of the above"], ["a) Each derived class does not have its own version of a virtual method","b) If a derived class does not have its own version of virtual method then one in base class is used","c) By default methods are virtual","d) All of the mentioned"], ["a) Static binding","b) Static Linking","c) Compile time polymorphism","d) All of the mentioned"]]
        let correctBool2 = [[0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 1, 0], [0, 0, 1, 0], [0, 0, 0, 1]]
        
        let answerSheet3 = [["a) Polymorphism","b) Inheritance","c) Templates","d) All of the mentioned"], ["a) 5","b) 4 ","c) 3","d) 2"], ["a) Scope resolution operator(:)","b) Class visibility modifiers (public,private etc.)","c) Dot operator (.)","d) All of the mentioned"], ["a) Private, protected, public, internal","b) Private, protected, public, internal, protected internal","c) Private, protected, public","d) All of the mentioned"], ["a) static","b) protected","c) private","d) share"]]
        let correctBool3 = [[0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0]]
        
        let answerSheet4 = [["a) Interfaces cannot be inherited","b) Interfaces consists of data static in nature and static methods","c) Interfaces consists of only method declaration","d) None of the mentioned "], ["a) Properties","b) Methods","c) Structures","d) Events"], ["a) 12 bytes","b) 16 bytes","c) 0 bytes","d) 24 bytes "], ["a) The calls to implementation of interface methods are routed through a method table ","b) A class which implements an interface can explicitly implement members of that interface","c) One interface can be implemented in another interface","d) None of the mentioned"], ["a) One class could implement only one interface","b) Properties could be declared inside an interface","c) Interfaces cannot be inherited","d) None of the mentioned"]]
        let correctBool4 = [[0, 0, 0, 1], [0, 0, 1, 0], [0, 0, 0, 1], [1, 0, 0, 0], [0, 0, 0, 1]]
        
        var questionId = 0 // counter for questionId
        //counter for correct bool
        var x = 0
        var y = 0
        for ques in answerSheet1 {
            questionId += 1
            for ans in ques{
                print("Question: ", questionId, "x: ", x, "y: ", y,"Answer: ",ans, "correct?: ", correctBool1[x][y])
                QuizDBHelper.dbHelper.insertAnswer(answerName: ans as NSString, isCorrect: correctBool1[x][y], questionId: questionId)
                y += 1
            }
            x += 1
            y = 0
        }
        
        x = 0
        y = 0
        for ques in answerSheet2 {
            questionId += 1
            for ans in ques{
                print("Question: ", questionId, "x: ", x, "y: ", y,"Answer: ",ans, "Correct?: ", correctBool2[x][y] )
                QuizDBHelper.dbHelper.insertAnswer(answerName: ans as NSString, isCorrect: correctBool2[x][y], questionId: questionId)
                y += 1
            }
            x += 1
            y = 0
        }
        
        x = 0
        y = 0
        for ques in answerSheet3 {
            questionId += 1
            for ans in ques{
                print("Question: ", questionId, "x: ", x, "y: ", y,"Answer: ",ans, "Correct?: ", correctBool3[x][y] )
                QuizDBHelper.dbHelper.insertAnswer(answerName: ans as NSString, isCorrect: correctBool3[x][y], questionId: questionId)
                y += 1
            }
            x += 1
            y = 0
        }
        
        x = 0
        y = 0
        for ques in answerSheet4 {
            questionId += 1
            for ans in ques{
                print("Question: ", questionId, "x: ", x, "y: ", y,"Answer: ",ans, "Correct?: ", correctBool4[x][y] )
                QuizDBHelper.dbHelper.insertAnswer(answerName: ans as NSString, isCorrect: correctBool4[x][y], questionId: questionId)
                y += 1
            }
            x += 1
            y = 0
        }
    }

}
