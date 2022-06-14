//
//  Player.swift
//  TakeItEasy
//
//  Created by Dhananjay H. Roy on 2022-06-14.
//

import Foundation
import AVFoundation



class Player
{
    var avplayer:AVPlayer!
//    var playerItem: AVPlayerItem!
    

    init()
    {
        avplayer = AVPlayer()
        
    }
    
    func playStream(fileUrl: String)
    {
        if let url = URL(string: fileUrl)
        {
            avplayer = AVPlayer(url: url)
            avplayer.play()
            print("Playing Stream")
            let songUrl = url
            print(songUrl)
        }
    }
    
    func playAudio()
    {
        if(avplayer?.rate == 0 && avplayer?.error == nil)
        {
            avplayer?.play()
        }
    }
    func pauseAudio()
    {
        if(avplayer!.rate > 0 && avplayer?.error == nil)
        {
            avplayer?.pause()
        }
    }
    
}


