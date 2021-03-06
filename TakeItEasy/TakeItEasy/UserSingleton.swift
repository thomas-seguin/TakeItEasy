//
//  UserSingleton.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-13.
//

import Foundation
import UIKit
class UserSingleton{
    static var userData = UserSingleton()
    var currentUsername = "Test2" // set the successfully loggedin username here at login/register for the Navbar's Username
    private init(){
        
    }
    
    //call on logout button action handler
    //How to call it: UserSingleton.userData.logout(view: self.view)
    func logout(view : UIView){
        //put the login view identifier in withIdentifier:
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Test")
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate, let window = sceneDelegate.window{
            window.rootViewController = loginVC
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil)
        }

    }
}
