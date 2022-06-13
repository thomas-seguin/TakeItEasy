//
//  APIModels.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-12.
//

import Foundation

//For Music API
struct SongResponse: Codable {
    let resultCount: Int
    let results: [Songs]
}
struct Songs: Codable {
    let trackId : Int
    let trackName : String
    let artistName : String
    let previewUrl : String
}
