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
    var newQuizViewModel = QuizViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.topItem?.title = UserSingleton.userData.currentUsername
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newQuizViewModel.quizzes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! QuizCollectionViewCell
        cell.quizLabel.text = newQuizViewModel.quizzes[indexPath.count].quizName
        cell.backgroundColor = UIColor.purple
        cell.layer.borderColor = CGColor(red: 100, green: 0, blue: 255, alpha: 1)
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0;
        cell.layer.masksToBounds = true;
        return cell
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
