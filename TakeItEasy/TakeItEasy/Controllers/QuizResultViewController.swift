//
//  QuizResultViewController.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-16.
//

import UIKit

class QuizResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var prevView = QuestionaireViewController()
    @IBOutlet weak var resultHeader: UILabel!
    @IBOutlet weak var resultImg: UIImageView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var codeTxtField: UITextField!
    var newQuizResultViewModel : QuizResultViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        if(newQuizResultViewModel!.didUserPass()){
            resultHeader.text = "Congratulations!"
            resultImg.image = UIImage(named: "passed-stamp-round-grunge-sign-label-181912691")
        }
        newQuizResultViewModel?.playSound()
        let num = String(Int(newQuizResultViewModel!.getScore()))
        scoreLbl.text = "Quiz Score: " + num + "%"
        pointsLbl.text = "Copy/Save and use this code at the FunZoneShop to redeem" + num + " points"
        codeTxtField.text = newQuizResultViewModel?.getCode()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newQuizResultViewModel!.getArrayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewTableViewCell
        cell.questionLbl.text = newQuizResultViewModel?.questionNames[indexPath.row]
        cell.answerLbl.text = newQuizResultViewModel?.correctAnswers[indexPath.row]
        cell.backgroundColor = UIColor.purple
        cell.layer.borderColor = CGColor(red: 100, green: 0, blue: 255, alpha: 1)
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0;
        cell.layer.masksToBounds = true;
        return cell
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        prevView.dismiss(animated: false)
    }

}
