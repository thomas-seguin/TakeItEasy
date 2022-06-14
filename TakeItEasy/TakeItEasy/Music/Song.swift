//
//  Song.swift
//  TakeItEasy
//
//  Created by Dhananjay H. Roy on 2022-06-14.
//

import Foundation

class Song
{
    var id: Int = 0
    var name: String
    var likes: Int
    var plays: Int


    init? (id: String, name: String, likes: String, plays: String)
    {
        self.id = Int(id)!
        self.name = name
        self.likes = Int(likes)!
        self.plays = Int(plays)!
    }
    
    func getID() -> Int
    {
        return id
    }
    func getName() -> String
    {
        return name
    }
    func getLikes() -> Int
    {
        return likes
    }
    func getPlays() -> Int
    {
        return plays
    }
    
    func getCleanName() -> String
    {
        let cleanName = name.dropLast(4)
        return String(cleanName)
    }

}

