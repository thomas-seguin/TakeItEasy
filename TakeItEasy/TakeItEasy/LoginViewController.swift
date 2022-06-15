//
//  LoginViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/10/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    let userDefaults = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        guard let data = KeyChainManger.get(service: "takeiteasy", account: email) else {
            print("failed to read password")
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
           
            
        }else {
           print("failed to login")
        }
        
    }
    
}
