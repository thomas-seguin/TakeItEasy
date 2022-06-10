//
//  RegisterViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/10/22.
//

import UIKit

class RegisterViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var fNameTxt: UITextField!
    @IBOutlet weak var lNameTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerClick(_ sender: Any) {
        createUser(email: emailTxt.text ?? "", fName: fNameTxt.text ?? "", lName: lNameTxt.text ?? "", phoneNumber: phoneTxt.text ?? "")
        
        do {
            try KeyChainManger.save(service: "takeiteasy",
                                    account: emailTxt.text ?? "",
                                    password: (passwordTxt.text ?? "").data(using: .utf8) ?? Data())
            
        } catch {
            print("failed to save to keychain")
        }
    }
    
    func createUser(email: String, fName: String, lName: String, phoneNumber:String){
        let newUser = User(context: context)
        newUser.email = email
        newUser.fName = fName
        newUser.lastName = lName
        newUser.phoneNumber = phoneNumber
        
        do{
            try context.save()
        } catch{
            print("failed to save user")
        }
    }

}
