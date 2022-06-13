//
//  MusicSearchManager.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-13.
//
import Foundation
import MusicKit
class MusicSearchManager{
    private var songList = [Songs]() //
    
    init(){
        loadSongs()
    }
    //Can't use AVFoundation to play songs from remote sourrce can use AVPlayer instead
    //Populated songList at instantiation
    func loadSongs(){
        //JSON file from itunes
        let url = URL(string: "https://itunes.apple.com/search?term=nirvana&media=music&entity=song&musicTrack")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          if let error = error {
            print(error)
          }
            guard let myData = data else {
                return
            }
            do {
                let response = try JSONDecoder().decode(SongResponse.self, from: myData)
                //print(response.results)
                self.songList = response.results

            } catch { print(error) }
        }
        .resume()
    }
    
    
    //Call when user searches a song
    //Return an array of objects Songs based on search parameter
    //songs has trackName, artistName, trackId, and previewUrl (check API Models)
    //use previewUrl to play track
    func searchSongs(searchParameter : String) -> [Songs]{
        if(searchParameter == ""){
            return songList
        }
        var searchResult = [Songs]()
        var i = 0
        while(i < songList.count){
            if(songList[i].trackName.lowercased().contains(searchParameter.lowercased()) || songList[i].artistName.lowercased().contains(searchParameter.lowercased())){
                searchResult.append(songList[i])
            }
            i += 1
        }
        return searchResult
    }
}
