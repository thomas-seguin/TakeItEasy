//
//  MusicData.swift
//  TakeItEasy
//
//  Created by Dhananjay H. Roy on 2022-06-21.
//

import Foundation
class MusicData
{
    var songName: String
    var albumImage: String
    var artistName: String
    
    
    init(pName: String, pImage: String,pArtist: String)
    {
        self.songName = pName
        self.albumImage = pImage
        self.artistName = pArtist
    }
}

