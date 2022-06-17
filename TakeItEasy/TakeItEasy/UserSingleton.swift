//
//  UserSingleton.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-13.
//

import Foundation
class UserSingleton{
    static var userData = UserSingleton()
    var currentUsername = "Test" // set the successfully loggedin username here at login/register for the Navbar's Username
    private init(){
        
    }
}
