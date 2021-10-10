//
//  Model.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/7/21.
//

import UIKit

struct AlbumJSONResult: Codable {
    let resultCount: Int
    let results: [Album]
}

struct SongsJSONResult: Codable {
    let results: [Song]
}

class Album: Codable, AlbumData {
    let albumName: String
    let artistName: String
    let trackCount: Int
    let albumImageLink: String
    let releaseDate: Date
    var imageData: Data?
    
    init(albumName: String, artistName: String, trackCount: Int, albumImageLink: String, releaseDate: Date, imageData: Data? = Data()) {
        self.albumName = albumName
        self.artistName = artistName
        self.trackCount = trackCount
        self.albumImageLink = albumImageLink
        self.releaseDate = releaseDate
        self.imageData = imageData
    }
    
    enum CodingKeys: String, CodingKey {
        case albumName = "collectionName"
        case artistName = "artistName"
        case trackCount
        case albumImageLink = "artworkUrl100"
        case releaseDate
        case imageData
    }
    
    public func addImageData(_ data: Data) {
        self.imageData = data
    }
}

struct Song: Codable {
    let name: String
    let artistName: String
    let collectionName: String
    let genre: String
    let trackNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artistName
        case collectionName
        case genre = "primaryGenreName"
        case trackNumber
    }
}

class AlbumDetails {
    let album: Album
    var songsList: [Song] = []
    
    init(with album: Album) {
        self.album = album
    }
    
    func add(_ songs: [Song]) {
        songsList.append(contentsOf: songs)
    }
}
