//
//  QuizViewController.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-14.
//

import UIKit

class QuizViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate{

    //Username and Logout Bar
    @IBOutlet weak var customBar: UINavigationBar!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var retakeWarning: UILabel!
    var newQuizViewModel = QuizViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.topItem?.title = UserSingleton.userData.currentUsername
        
//        let test = QuizDBHelper.dbHelper.getAllUserResults(username: UserSingleton.userData.currentUsername as NSString)
//        print(test)
//        for x in test{
//            print(x.resultId,x.username,x.quizId,x.userScore)
//        }
    
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newQuizViewModel.searchedQuizzes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! QuizCollectionViewCell
        cell.quizLabel.text = newQuizViewModel.searchedQuizzes[indexPath.row].quizName
        cell.backgroundColor = UIColor.purple
        cell.layer.borderColor = CGColor(red: 100, green: 0, blue: 255, alpha: 1)
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0;
        cell.layer.masksToBounds = true;
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        newQuizViewModel.getSearchedQuizzes(searchText: searchText)
        myCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(!newQuizViewModel.haveUserDoneQuiz(index : indexPath.row))
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let questionaire = storyboard.instantiateViewController(withIdentifier: "Questionaire") as! QuestionaireViewController
            let obj = QuestionaireViewModel(q : newQuizViewModel.searchedQuizzes[indexPath.row])
            questionaire.newQuestionaireViewModel = obj
            print(newQuizViewModel.searchedQuizzes[indexPath.row].quizName!)
            retakeWarning.isHidden = true
            present(questionaire, animated: true)
            
        }
        else{
            retakeWarning.isHidden = false
        }
    }
    
//MARK: For Testing purposes
    func testingQuestionaires(){
        for quiz in newQuizViewModel.quizzes{
            print(quiz.quizId!,quiz.quizName!,quiz.totalScore)
            for question in quiz.questions!{
                print(question.quizId! ,question.questionid!, question.questionName!, question.score!)
                for answer in question.answers!{
                    print(answer.questionId!, answer.answerId!, answer.answerName!, answer.isCorrect!)
                }
            }
        }
    }
    
}

