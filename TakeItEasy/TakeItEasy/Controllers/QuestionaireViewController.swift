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
    @IBOutlet weak var selectWarning_Lbl: UILabel!
    var newQuestionaireViewModel :  QuestionaireViewModel?
    var currentQuesNum = 0
    var answersArray : [Answer] = []
    var selectedAnswer : Answer?
    var prevSelected : IndexPath?
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
        cell.backgroundColor = UIColor(named: "Cell")
        cell.layer.borderColor = CGColor(red: 100, green: 0, blue: 255, alpha: 1)
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0;
        cell.layer.masksToBounds = true;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(prevSelected != nil){
            tableView.cellForRow(at: prevSelected!)!.backgroundColor = UIColor.purple
        }
        selectedAnswer = answersArray[indexPath.row]
        selectWarning_Lbl.isHidden = true
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor(named: "MainButton")
        prevSelected = indexPath
        
    }
    
    
    @IBAction func submit_Btn(_ sender: Any) {
  
        if(selectedAnswer != nil)
        {
            newQuestionaireViewModel?.submitAnswer(ans: selectedAnswer!, currentQues: currentQuesNum)
            currentQuesNum += 1
            
        }
        else{
            selectWarning_Lbl.isHidden = false
        }
        if(currentQuesNum == newQuestionaireViewModel!.quiz.questions!.count){
            guard let quizResult = newQuestionaireViewModel?.submitAndGetQuizResult() else { return }
            let newQuizResultModel = QuizResultViewModel(res: quizResult)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = storyboard.instantiateViewController(withIdentifier: "QuizResult") as! QuizResultViewController
            nextView.prevView = self
            nextView.newQuizResultViewModel = newQuizResultModel
            present(nextView, animated: true)
                
            
        }
        else{
            questionName_Lbl.text = newQuestionaireViewModel?.getQuestionName(currentQues: currentQuesNum)
            answersArray = (newQuestionaireViewModel?.getAnswers(currentQues: currentQuesNum))!
            selectedAnswer = nil
            answersTable.reloadData()
        }
        
    }
    
    
}
