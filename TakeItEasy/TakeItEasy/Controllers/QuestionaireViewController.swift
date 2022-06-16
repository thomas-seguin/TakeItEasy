//
//  QuestionaireViewController.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-16.
//

import UIKit

class QuestionaireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var quizName_Lbl: UILabel!
    @IBOutlet weak var questionName_Lbl: UILabel!
    @IBOutlet weak var answersTable: UITableView!
    var newQuestionaireViewModel :  QuestionaireViewModel?
    var currentQuesNum = 0
    var answersArray : [Answer] = []
    var selectedAnswer : Answer?
//    var selectedRow : IndexPath = []
    override func viewDidLoad() {
        super.viewDidLoad()
        quizName_Lbl.text = newQuestionaireViewModel?.quiz.quizName
        questionName_Lbl.text = newQuestionaireViewModel?.getQuestionName(currentQues: currentQuesNum)
        answersArray = (newQuestionaireViewModel?.getAnswers(currentQues: currentQuesNum))!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! QuestionaireTableViewCell
        cell.answerLbl.text = answersArray[indexPath.row].answerName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedAnswer = answersArray[indexPath.row]
        //tableView.deselectRow(at: selectedRow, animated: true)
        //selectedRow = indexPath
    }
    
    @IBAction func submit_Btn(_ sender: Any) {
  
        if(selectedAnswer != nil)
        {
            newQuestionaireViewModel?.submitAnswer(ans: selectedAnswer!, currentQues: currentQuesNum)
            currentQuesNum += 1
            
        }
        if(currentQuesNum == newQuestionaireViewModel!.quiz.questions!.count){
            print(newQuestionaireViewModel?.submitQuizResult() ?? 0)
            
        }
        
        questionName_Lbl.text = newQuestionaireViewModel?.getQuestionName(currentQues: currentQuesNum)
        answersArray = (newQuestionaireViewModel?.getAnswers(currentQues: currentQuesNum))!
        selectedAnswer = nil
        answersTable.reloadData()

    }
    
}
