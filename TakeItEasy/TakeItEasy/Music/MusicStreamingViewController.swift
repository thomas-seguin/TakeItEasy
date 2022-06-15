//
//  MusicStreamingViewController.swift
//  TakeItEasy
//
//  Created by Dhananjay H. Roy on 2022-06-14.
//

import UIKit
import AVFoundation
import WebKit


class MusicStreamingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchResultsUpdating {
    
    
    
    var songs = [Song]()
    var player: Player!
    var musicURL: URL!
    
    
    var mplayer:AVPlayer?
    var playerItem:AVPlayerItem?
    fileprivate let seekDuration: Float64 = 10
    
    @IBOutlet weak var lblOverallDuration: UILabel!
    @IBOutlet weak var lblcurrentText: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    
    @IBOutlet weak var currentSong: UILabel!
    @IBOutlet weak var MusicCollectionView: UICollectionView!
    
    
    
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        player = Player()
        retrieveSongs()
        
        let mplay = AVPlayer()
        if let currentItem = mplay.currentItem {
            let duration = currentItem.asset.duration
        }
            let currenTime = mplay.currentTime()
        
        print()
        
    }
    
    @IBAction func volumeControl(_ sender: UISlider) {
        player.avplayer.volume = sender.value
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
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
    
    @objc func updateTime()
    {
       

//        musicSlider.value = Float(audioPlayer!.currentTime)
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
            for s in songs
            {
                print(s.getName())
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
        
        cell.songName.text = songs[indexPath.row].getCleanName()
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        player.playStream(fileUrl: "https://infinitesimal-strob.000webhostapp.com/music_app/" + songs[indexPath.row].getName())
        currentSong.text = songs[indexPath.row].getCleanName()
    }
    
    
    @IBAction func ButtonPlay(_ sender: Any) {
        if (player.avplayer!.rate > 0)
        {
            player?.pauseAudio()
            print("Music Pause")
            
        }
        else
        {
            player?.playAudio()
            print("Music Playing")
            
        }
        
    }
    
    
}
