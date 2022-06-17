//
//  LoginViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/10/22.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    let userDefaults = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        let bottomLine = CALayer()
        let bottomLine2 = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: emailTxt.frame.height - 1, width: emailTxt.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        
        bottomLine2.frame = CGRect(x: 0, y: passTxt.frame.height - 1, width: passTxt.frame.width, height: 1)
        bottomLine2.backgroundColor = UIColor.black.cgColor
        
        
        emailTxt.borderStyle = UITextField.BorderStyle.none
        emailTxt.layer.addSublayer(bottomLine)
        passTxt.borderStyle = UITextField.BorderStyle.none
        passTxt.layer.addSublayer(bottomLine2)
        
        let leftImageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftImageView1.image = UIImage(systemName: "mail")
        emailTxt.leftView = leftImageView1
        emailTxt.leftView?.tintColor = .black
        emailTxt.leftViewMode = .always
        
        
        let leftImageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftImageView2.image = UIImage(systemName: "lock")
        
     
        
        passTxt.leftView = leftImageView2
        passTxt.leftView?.tintColor = .black
        passTxt.leftViewMode = .always
        
        passTxt.enablePasswordToggle()
        passTxt.enablePasswordToggle()
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func textChange(_ sender: Any) {
        if emailTxt.text != nil{
            loginButton.isEnabled = true
        }
    }
    @IBAction func loginClick(_ sender: Any) {
        
        let email = emailTxt.text ?? "test"
        let pass = passTxt.text
        
        test.text = email
        guard let data = KeyChainManger.get(service: "takeiteasy", account: email) else {
            
            return
        }
        let password = String(decoding: data, as: UTF8.self)
        if(password == pass){
            test.text = "logged in"
            
            if rememberSwitch.isOn{
                
                userDefaults.set(true, forKey: "remember")
            } else {
               
                userDefaults.set(false, forKey: "remember")
            }
            
            print("logged in")
            let loggedUser = searchUser(searchParameter: email)
            for user in loggedUser{
                UserSingleton.userData.currentUsername = user.fName ?? "bob"
            }
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "main")else {
                return
            }
            //vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            
        }else {
            test.text = "failed"
           print("failed to login")
        }
        
    }
    
    func searchUser(searchParameter : String) -> [User]{
        var users = [User]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "email CONTAINS[cd] %@", searchParameter)
        do{
            users = try context?.fetch(fetchRequest) as! [User]
            print("data fetched")
        }
        catch{
            print("cannot fetch data")
        }
        return users
        
    }
}


extension UITextField {
fileprivate func setPasswordToggleImage(_ button: UIButton) {
    if(isSecureTextEntry){
        button.setImage(UIImage(systemName: "eye"), for: .normal)
    }else{
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)

    }
}
    


func enablePasswordToggle(){
    let button = UIButton(type: .custom)
    setPasswordToggleImage(button)
   
    button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
    button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
    self.rightView = button
    self.rightView?.tintColor = .black
    self.rightViewMode = .always
}
@IBAction func togglePasswordView(_ sender: Any) {
    self.isSecureTextEntry = !self.isSecureTextEntry
    setPasswordToggleImage(sender as! UIButton)
}
}
