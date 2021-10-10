//
//  DataController.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/9/21.
//

import Foundation

protocol AlbumsDataSource {
    func loadAlbums(for group: String, with completion: @escaping (Result<[Album], NetworkError>) -> Void)
}

protocol HistoryDataSource {
    func fetchHistoryURLs(completion: @escaping ([HistoryData]) -> Void)
}

protocol DetailDataSource {
    func fetchDetails(for album: Album, with completion: @escaping (Result<AlbumDetails, NetworkError>) -> Void)
}

final class DataController {
    
    private let networkController: NetworkController
    private var storageController: StorageController
    weak var dataUser: DataUserDelegate?
    
    var history: [HistoryData]
    
    init() {
        self.history = []
        self.networkController = NetworkController()
        self.storageController = StorageController()
        networkController.dataUser = self
    }
    
    func saveToHistory(_ data: HistoryData) {
        storageController.save(history: data)
        self.history.append(data)
    }
}

extension DataController: AlbumsDataSource {
    
    func loadAlbums(for group: String, with completion: @escaping (Result<[Album], NetworkError>) -> Void) {
        var albumsResource = AlbumsResource()
        albumsResource.addGroup(name: group)
        networkController.loadAlbums(for: albumsResource.url) { [weak self] (result) in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success(let albums):
                completion(.success(albums))
                self?.saveToHistory(HistoryData(groupName: group, link: albumsResource.url.absoluteString))
            }
        }
    }
}

extension DataController: HistoryDataSource {
    func fetchHistoryURLs(completion: ([HistoryData]) -> Void) {
        guard let urls = storageController.fetchURLs() else { return }
        completion(urls)
    }
}

extension DataController: DetailDataSource {
    func fetchDetails(for album: Album, with completion: @escaping (Result<AlbumDetails, NetworkError>) -> Void) {
        let albumDetails = AlbumDetails(with: album)
        var songsResource = SongsResource()
        songsResource.addAlbum(name: album.albumName)
        networkController.loadSongs(with: songsResource.url) { (result) in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success(let songs):
                let filteredSongs = songs.filter { $0.collectionName == album.albumName && $0.artistName == album.artistName }
                DispatchQueue.main.async {
                    albumDetails.add(filteredSongs.sorted(by: { $0.trackNumber < $1.trackNumber }))
                    completion(.success(albumDetails))
                }
            }
        }
    }
}

extension DataController: DataUserDelegate {
    func dataEndLoading() {
        self.dataUser?.dataEndLoading()
    }
}
