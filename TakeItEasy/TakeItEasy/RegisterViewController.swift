//
//  RegisterViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/10/22.
//

import UIKit
import UserNotifications

class RegisterViewController: UIViewController {
    var regUser = User()
    let emailPattern = #"^\S+@\S+\.\S+$"#
    let phonePattern = #"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$"#
    var validEmail: Bool = false
    var validPhone: Bool = false
    var validFName: Bool = false
    var validLName: Bool = false
    var validPass: Bool = false
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
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]){ (granted, error) in }
        
        let content = UNMutableNotificationContent()
        content.title = "Verification Code"
        content.body = "Your verification code is 1234"
        
        let date = Date().addingTimeInterval(5)
        
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuid = UUID().uuidString
        let req = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        center.add(req){ (error) in
            print("error sending")
        }
        
        let bottomLine = CALayer()
        let bottomLine2 = CALayer()
        let bottomLine3 = CALayer()
        let bottomLine4 = CALayer()
        let bottomLine5 = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: emailTxt.frame.height - 1, width: emailTxt.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        
        bottomLine2.frame = CGRect(x: 0, y: passwordTxt.frame.height - 1, width: passwordTxt.frame.width, height: 1)
        bottomLine2.backgroundColor = UIColor.black.cgColor
        
        
        bottomLine3.frame = CGRect(x: 0, y: fNameTxt.frame.height - 1, width: fNameTxt.frame.width, height: 1)
        bottomLine3.backgroundColor = UIColor.black.cgColor
        
        bottomLine4.frame = CGRect(x: 0, y: lNameTxt.frame.height - 1, width: lNameTxt.frame.width, height: 1)
        bottomLine4.backgroundColor = UIColor.black.cgColor
        
        bottomLine5.frame = CGRect(x: 0, y: phoneTxt.frame.height - 1, width: phoneTxt.frame.width, height: 1)
        bottomLine5.backgroundColor = UIColor.black.cgColor
        
        
        emailTxt.borderStyle = UITextField.BorderStyle.none
        emailTxt.layer.addSublayer(bottomLine)
        passwordTxt.borderStyle = UITextField.BorderStyle.none
        passwordTxt.layer.addSublayer(bottomLine2)
        fNameTxt.borderStyle = UITextField.BorderStyle.none
        fNameTxt.layer.addSublayer(bottomLine3)
        lNameTxt.borderStyle = UITextField.BorderStyle.none
        lNameTxt.layer.addSublayer(bottomLine4)
        phoneTxt.borderStyle = UITextField.BorderStyle.none
        phoneTxt.layer.addSublayer(bottomLine5)
        
        let leftImageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftImageView1.image = UIImage(systemName: "mail")
        emailTxt.leftView = leftImageView1
        emailTxt.leftView?.tintColor = .black
        emailTxt.leftViewMode = .always
        
        
        let leftImageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftImageView2.image = UIImage(systemName: "lock")
        
        passwordTxt.leftView = leftImageView2
        passwordTxt.leftView?.tintColor = .black
        passwordTxt.leftViewMode = .always
        
        let leftImageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftImageView3.image = UIImage(systemName: "person.fill")
        
        fNameTxt.leftView = leftImageView3
        fNameTxt.leftView?.tintColor = .black
        fNameTxt.leftViewMode = .always
        
        let leftImageView4 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftImageView4.image = UIImage(systemName: "person.fill")
        
        lNameTxt.leftView = leftImageView4
        lNameTxt.leftView?.tintColor = .black
        lNameTxt.leftViewMode = .always
        
        let leftImageView5 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftImageView5.image = UIImage(systemName: "phone.fill")
        
        phoneTxt.leftView = leftImageView5
        phoneTxt.leftView?.tintColor = .black
        phoneTxt.leftViewMode = .always
        
        
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func registerClick(_ sender: Any) {
        errorLabel.text = "start"
        
        let passwordPattern = #"(?=.{8,})"#
       
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
            UserSingleton.userData.currentUsername = fNameTxt.text ?? "empty"
        
        do {
            try KeyChainManger.save(service: "takeiteasy",
                                    account: emailTxt.text ?? "",
                                    password: (passwordTxt.text ?? "").data(using: .utf8) ?? Data())
            
        } catch {
            print("failed to save to keychain")
        }
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "OTP") as? OTPViewController else {
                return
            }
            vc.user = regUser
            present(vc, animated: true)
            
        }else {
            //errorLabel.text = "bad input"
        }
    }
    
    
    
    
    @IBAction func emailChange(_ sender: Any) {
        let email = emailTxt.text
        var result = email?.range(of: emailPattern, options: .regularExpression)
        validEmail = (result != nil)
        
        let validView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        validView.image = UIImage(systemName: "checkmark")
        let invalidView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        invalidView.image = UIImage(systemName: "xmark.circle")
        
        
        if(!validEmail){
        emailTxt.rightView = invalidView
        emailTxt.rightView?.tintColor = .red
        emailTxt.rightViewMode = .always
        } else if(validEmail){
            emailTxt.rightView = validView
            emailTxt.rightView?.tintColor = .green
            emailTxt.rightViewMode = .always
            
        }
        if checkValid(){
            signupButton.isEnabled = true
        }
    }
    
    @IBAction func fNameChange(_ sender: Any){
        fNameTxt.rightViewMode = .always
        let validView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        validView.image = UIImage(systemName: "checkmark")
        let invalidView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        invalidView.image = UIImage(systemName: "xmark.circle")
        if fNameTxt.text != nil {
            validFName = true
            fNameTxt.rightView = validView
            fNameTxt.rightView?.tintColor = .green
        } else {
            fNameTxt.rightView = invalidView
            fNameTxt.rightView?.tintColor = .red
        }
        if checkValid(){
            signupButton.isEnabled = true
        }
    }
    
    
    @IBAction func passChange(_ sender: Any){
        passwordTxt.rightViewMode = .always
        let validView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        validView.image = UIImage(systemName: "checkmark")
        let invalidView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        invalidView.image = UIImage(systemName: "xmark.circle")
        if passwordTxt.text != nil {
            validPass = true
            passwordTxt.rightView = validView
            passwordTxt.rightView?.tintColor = .green
        } else {
            passwordTxt.rightView = invalidView
            passwordTxt.rightView?.tintColor = .red
        }
        if checkValid(){
            signupButton.isEnabled = true
        }
    }
    
    @IBAction func lNameChange(_ sender: Any){
        lNameTxt.rightViewMode = .always
        let validView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        validView.image = UIImage(systemName: "checkmark")
        let invalidView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        invalidView.image = UIImage(systemName: "xmark.circle")
        if lNameTxt.text != nil {
            validLName = true
            lNameTxt.rightView = validView
            lNameTxt.rightView?.tintColor = .green
        } else {
            lNameTxt.rightView = invalidView
            lNameTxt.rightView?.tintColor = .red
        }
        if checkValid(){
            signupButton.isEnabled = true
        }
    }
    
    @IBAction func phoneChange(_ sender: Any) {
        let phone = phoneTxt.text
        var result = phone?.range(of: phonePattern, options: .regularExpression)
        validPhone = (result != nil)
        
        let validView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        validView.image = UIImage(systemName: "checkmark")
        let invalidView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        invalidView.image = UIImage(systemName: "xmark.circle")
        
        
        if(!validPhone){
        phoneTxt.rightView = invalidView
        phoneTxt.rightView?.tintColor = .red
        phoneTxt.rightViewMode = .always
        } else if(validPhone){
            phoneTxt.rightView = validView
            phoneTxt.rightView?.tintColor = .green
            phoneTxt.rightViewMode = .always
            
        }
        if checkValid(){
            signupButton.isEnabled = true
        }
    }
    
    func checkValid() -> Bool{
        return validPhone && validEmail && validPass && validFName && validLName
    }
    
    
    func createUser(email: String, fName: String, lName: String, phoneNumber:String){
        let newUser = User(context: context)
        
        newUser.email = email
        newUser.fName = fName
        newUser.lastName = lName
        newUser.phoneNumber = phoneNumber
        newUser.verified = 0
        
        do{
            try context.save()
            regUser = newUser
            
        } catch{
            print("failed to save user")
        }
    }

}
