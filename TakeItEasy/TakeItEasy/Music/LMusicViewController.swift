//
//  LMusicViewController.swift
//  TakeItEasy
//
//  Created by Dhananjay H. Roy on 2022-06-20.
//

import UIKit
import AVFoundation

var thisSong = ""
var thisArtist = ""
class LMusicViewController: UIViewController{
    
    @IBOutlet weak var myTable: UITableView!
    var musicList = [MusicData]()
    var searching = false
    var musicArray = [MusicData]()
    
    @IBOutlet weak var tableViewResult: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMusicList()
        configureSearchController()
        myTable.isHidden = true
       
    }
    
    func initMusicList()
    {
        let song1 = MusicData(pName: "Augenbling", pImage: "Augenbling", pArtist: "Seeed")
        musicList.append(song1)
        let song2 = MusicData(pName: "On the precipice", pImage: "Bleach",pArtist: "Bleach Anime" )
        musicList.append(song2)
        let song3 = MusicData(pName: "Carnival of rust", pImage: "Carnival", pArtist: "Poets Of The Fall")
        musicList.append(song3)
        let song4 = MusicData(pName: "Boulevard", pImage: "GreenDay", pArtist: "Green Day")
        musicList.append(song4)
        let song5 = MusicData(pName: "Bad Habits", pImage: "Ed", pArtist: "Ed Sheeran")
        musicList.append(song5)
        let song6 = MusicData(pName: "Find Love", pImage: "kaskade", pArtist: "Kaskade")
        musicList.append(song6)
        let song7 = MusicData(pName: "Last resort", pImage: "Paparoach", pArtist: "Paparoach")
        musicList.append(song7)
        let song8 = MusicData(pName: "Tujhe", pImage: "Kabir", pArtist: "Arijit Singh")
        musicList.append(song8)
        let song9 = MusicData(pName: "Volume High Karle", pImage: "Volume", pArtist: "Various")
        musicList.append(song9)
        
    }
    
    private func configureSearchController()
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false   //it wont allow the phone back light to go dim during search
        searchController.searchBar.enablesReturnKeyAutomatically = false //to remove search button from keyboard to done
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        //prevents hinding searchbar during scrolling result
        definesPresentationContext = true
        //to display search bar properly
        searchController.searchBar.placeholder = "Search Music By Name"
    }
    
    @IBAction func LogOutButton(_ sender: Any) {
        UserSingleton.userData.logout(view: self.view)
    }
    
}

extension LMusicViewController: UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return musicArray.count
        }
        else{
            return musicList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellcell", for: indexPath) as! LocalTableViewCell
        
        if searching{
            cell.songName.text = musicArray[indexPath.row].songName
            cell.songImg.image = UIImage(named: musicArray[indexPath.row].albumImage)
            cell.artistName.text = musicArray[indexPath.row].artistName
            thisSong = musicArray[indexPath.row].songName
            thisArtist = musicArray[indexPath.row].albumImage
            print(thisSong,"thisSongArr")
        }
        else
        {
            cell.songName.text = musicList[indexPath.row].songName
            cell.songImg.image = UIImage(named: musicList[indexPath.row].albumImage)
            cell.artistName.text = musicList[indexPath.row].artistName
            thisSong = musicList[indexPath.row].songName
            thisArtist = musicList[indexPath.row].albumImage
            print(thisSong,"thissonglist")
        }
        return cell
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        //musicArray.removeAll()
        myTable.isHidden = false
        myTable.reloadData()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty
        {
            myTable.isHidden = false
            searching = true
            musicArray.removeAll()
            for song in musicList
            {
                if song.songName.lowercased().contains(searchText.lowercased())
                {
                    musicArray.append(song)
                }
            }
        }
        else
        {
            searching = false
            musicArray.removeAll()
            musicArray = musicList
        }
        myTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
                var storyboard = UIStoryboard(name:"Main", bundle: nil)
                let playerScreen = storyboard.instantiateViewController(withIdentifier: "play") as! MPlayerViewController
                playerScreen.musicFile = musicArray[indexPath.row].songName
                playerScreen.incomingTemp2 = musicArray[indexPath.row].albumImage
                self.present(playerScreen, animated:  true, completion: nil)
            
        }
}


