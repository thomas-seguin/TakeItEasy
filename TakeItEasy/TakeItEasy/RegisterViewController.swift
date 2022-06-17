//
//  RegisterViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/10/22.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
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
        errorLabel.text = "start"
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let passwordPattern = #"(?=.{8,})"#
        let phonePattern = #"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$"#
        var valid = true
        
        if fNameTxt.text?.range(of: #"[a-zA-Z]"#,options: .regularExpression) == nil{
            print("fname fail")
            valid = false
        }
        
        if lNameTxt.text?.range(of: #"[a-zA-Z]"#,options: .regularExpression) == nil{
            print("lname fail")
            valid = false
        }
        
        
        
        
        let passResult = passwordTxt.text?.range(of: passwordPattern, options: .regularExpression)
        
        
        
        
        
        if(passResult == nil){
            print("bad pass")
            valid = false
        }
        
        if valid{
            errorLabel.text = "creating"
        createUser(email: emailTxt.text ?? "", fName: fNameTxt.text ?? "", lName: lNameTxt.text ?? "", phoneNumber: phoneTxt.text ?? "")
        
        do {
            try KeyChainManger.save(service: "takeiteasy",
                                    account: emailTxt.text ?? "",
                                    password: (passwordTxt.text ?? "").data(using: .utf8) ?? Data())
            
        } catch {
            print("failed to save to keychain")
        }
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "main")else {
                return
            }
            present(vc, animated: true)
            
        }else {
            //errorLabel.text = "bad input"
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
