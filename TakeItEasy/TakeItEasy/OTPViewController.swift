//
//  OTPViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/19/22.
//

import UIKit

class OTPViewController: UIViewController {
    public var user = User()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var otpLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: otpLabel.frame.height - 1, width: otpLabel.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        
        otpLabel.borderStyle = UITextField.BorderStyle.none
        otpLabel.layer.addSublayer(bottomLine)
    }
    
    @IBAction func otpChange(_ sender: Any) {
        print("change")
        guard let text = otpLabel?.text else {
            return
        }
        if(text == "1234"){
            updateItem(user: user)
            print("present")
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "main")else {
                return
            }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            
        }
    }
    
    func updateItem(user: User){
        user.verified = 1
        do{
            try context.save()
        } catch{
            print("faield to update item")
        }
    }
}


