//
//  MusicStreamingViewController.swift
//  TakeItEasy
//
//  Created by Dhananjay H. Roy on 2022-06-14.
//

import UIKit
import AVFoundation
import WebKit


class MusicStreamingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var songs = [Song]()
    var player: Player!
    var musicURL: URL!
    
    @IBOutlet weak var beginTimer: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var retArray = [String]()
    
    var albumImage = ["img 1","img 2","img 3","img 4","img 5","img 6","img 7","img 8","img 9","img 10","img 11"]
    
//    var songList:[Int: String] = [56:"Allthat.mp3",57:"Creativeminds.mp3",58:"Dreams.mp3",59:"Elevate.mp3",60:"Funday.mp3",61:"Hey.mp3",62:"Inspire.mp3",63:"Jazzyfrenchy.mp3",64:"Onceagain.mp3",65:"Photoalbum.mp3",66:"Ukulele.mp3"]
    
    var songList:[Int: String] = [:]
    
    
    var currentSongName = ""
    
    var mplayer:AVPlayer?
    var playerItem:AVPlayerItem?
    
    @IBOutlet weak var volumeControlSlider: UISlider!
    let userDefaults = UserDefaults()
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var currentSong: UILabel!
    @IBOutlet weak var MusicCollectionView: UICollectionView!
    
    var indexNumber = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = Player()
        retrieveSongs()
        
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
//        volumeControlSlider.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / -2))
        
    }
    
    @IBAction func LogOutButton(_ sender: Any) {
        userDefaults.set(false, forKey: "remember")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func volumeControl(_ sender: UISlider) {
        player.avplayer.volume = sender.value
    }
    
    
    func retrieveSongs()
    {
        //get all the data from the web call
        let url = URL(string: "https://infinitesimal-strob.000webhostapp.com/music_app/getmusic.php")!
        
        //does a background task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let retrievedList = String(data: data!, encoding: String.Encoding.utf8)
            print("Printing Retrived List")
            print(retrievedList)
            self.parseSongs(data: retrievedList!)
        }
        task.resume()
        print("Getting Songs")
    }

    func parseSongs(data: String)
    {
        if(data.contains("*"))
        {
            let dataArray = (data as String).split(separator: "*").map(String.init)
            for item in dataArray
            {
                let itemData = item.split(separator: ",").map(String.init)
                let newSong = Song(id: itemData[0], name: itemData[1], likes: itemData[2], plays: itemData[3])
                songs.append(newSong!)
            }
            print("IndexNumber",indexNumber)
            for s in songs
            {
                print(s.getName())
                songList[s.id] = s.getName()
                print(songList)
            }
            DispatchQueue.main.async
            {
                self.MusicCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCell", for: indexPath) as! SongsCollectionViewCell
        
        cell.albumImage.image = UIImage(named: albumImage[indexPath.row])
        cell.songName.text = songs[indexPath.row].getCleanName()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        player.playStream(fileUrl: "https://infinitesimal-strob.000webhostapp.com/music_app/" + songs[indexPath.row].getName())
        currentSong.text = songs[indexPath.row].getCleanName()
        currentSongName = songs[indexPath.row].getName()
        count = songs[indexPath.row].id
        print("song id",count)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getTime), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func playPauseButtonClick(_ sender: Any) {
        if (player.avplayer!.rate > 0)
        {
            player?.pauseAudio()
            print("Music Pause")
            
        }
        else
        {
            player?.playAudio()
            print("Music Playing")
            getTime()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getTime), userInfo: nil, repeats: true)
        }
    }
    
    var timer : Timer?
    
  @objc func getTime()
    {
        var audioStartTime: CMTime = CMTimeMake(value: 10, timescale: 1)
       
        let currentTime = player.avplayer.currentTime()
        let runningTime = CMTimeGetSeconds(currentTime)
        
        let duration = player.avplayer.currentItem!.asset.duration
        let seconds = CMTimeGetSeconds(duration)
        let secondsText = Int(seconds) % 60
        let minutesText = Int(seconds) / 60
        durationLabel.text = "\(minutesText):\(secondsText)"
        
        let cSeconds = Int(runningTime)
        print("Current",cSeconds)
        let cMinutes = Int(cSeconds) / 60
        let cSec = cSeconds - cMinutes * 60
        beginTimer.text = String(format: "%02d:%02d", cMinutes,cSec) as String
        progressBar.progress = Float(runningTime)/Float(seconds)
    }
    
        
    var count = 1

    @IBAction func NextSong(_ sender: Any)
    {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getTime), userInfo: nil, repeats: true)
        print("Current Song", currentSongName)
        for (key, value) in songList
        {
            if count <= songList.keys.min()!
            {
                count = songList.keys.max()!
                print(count)
            }
            print(songList.keys.max()!)
            print(songList.keys.min()!)
            print("Count before",count)
            
            if (currentSongName == songList[count])
            {
                print(currentSongName,songList[count]!)
                count = count - 1
                player?.pauseAudio()
                player.playStream(fileUrl: "https://infinitesimal-strob.000webhostapp.com/music_app/"+(songList[count] ?? "")!)
                print(songList[count] ?? "")
                currentSongName = ""
                let cleanName = songList[count]!.dropLast(4)
                currentSong.text = String(cleanName)
                currentSongName = songList[count] ?? ""
                print("Count After",count)
                print("list",songList[count] ?? "")
                print(currentSongName,songList[count]!)
                print("https://infinitesimal-strob.000webhostapp.com/music_app/",songList[count] ?? "")
                break
            }
            break
        }
    }
    
    
    @IBAction func PreviousSongButton(_ sender: Any)
    {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getTime), userInfo: nil, repeats: true)
        print("Current Song", currentSongName)
        for (key, value) in songList
        {
            if count > songList.keys.max()!
            {
                count = songList.keys.min()!
                print(count)
            }
            print(songList.keys.max()!)
            print(songList.keys.min()!)
            print("Count before",count)
            
            if (currentSongName == songList[count])
            {
                print(currentSongName,songList[count]!)
                count = count + 1
                player?.pauseAudio()
                player.playStream(fileUrl: "https://infinitesimal-strob.000webhostapp.com/music_app/"+(songList[count] ?? "")!)
                print(songList[count] ?? "")
                currentSongName = ""
                let cleanName = songList[count]!.dropLast(4)
                currentSong.text = String(cleanName)
                currentSongName = songList[count] ?? ""
                print("Count After",count)
                print("list",songList[count] ?? "")
                print(currentSongName,songList[count]!)
                print("https://infinitesimal-strob.000webhostapp.com/music_app/",songList[count] ?? "")
                break
            }
            break
        }
    }
    

}


