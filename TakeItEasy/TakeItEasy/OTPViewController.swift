//
//  OTPViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/19/22.
//

import UIKit

class OTPViewController: UIViewController,UNUserNotificationCenterDelegate{
    let randomInt = Int.random(in: 1000..<9999)
    public var user = User()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var otpLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().getNotificationSettings { notify in
            switch notify.authorizationStatus{
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options : [.alert, .sound, .badge]){ granted, err in
                    if let error = err{
                        print("error in permission", error)
                    }
                    self.generateNotification()
                }
            case .authorized:
                self.generateNotification()
            case .denied:
                print("permission not given")
            default:
                print("")
            }
        }
        
        
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
        if(text == String(randomInt)){
            updateItem(user: user)
            print("present")
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "main")else {
                return
            }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
    }
    
    func generateNotification(){
        let otp = String(randomInt)
        let content = UNMutableNotificationContent()
        content.title = "New Msg"
        content.subtitle = "from TakeItEasy App"
        content.body = "your otp is \(otp)"
        let timeInterval = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(identifier: "User_App_Notification", content: content, trigger: timeInterval)
        UNUserNotificationCenter.current().add(request){err in
            print("error", err)
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


