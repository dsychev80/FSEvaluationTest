//
//  NetworkService.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/8/21.
//

import Foundation

protocol DataUserDelegate: class {
    func dataEndLoading()
}

enum NetworkError: LocalizedError {
    case serverError(String)
    case clientError(String)
    case missingData
    case decodingError(String)
    case unknownError
}

class NetworkController {
    
    public weak var dataUser: DataUserDelegate?
    
    public func loadSongs(with url: URL, completion: @escaping (Result<[Song], NetworkError>) -> Void) {
        let _ = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                completion(.failure(.serverError(error!.localizedDescription)))
                return
            }
            do {
                let jsonData = try JSONDecoder().decode(SongsJSONResult.self, from: data)
               
                DispatchQueue.main.async {
                    guard jsonData.results.count != 0 else {
                        completion(.failure(.missingData))
                        return
                    }
                    completion(.success(jsonData.results))
                }
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }.resume()
    }
    
    public func loadAlbums(for url: URL, with completion: @escaping (Result<[Album], NetworkError>) -> Void) {
        
        let _ = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
              guard error == nil, let data = data else {
                completion(.failure(.serverError(error!.localizedDescription)))
                  return	
              }
              do {
                  let decoder = JSONDecoder()
                  decoder.dateDecodingStrategy = .iso8601
                  let jsonData = try decoder.decode(AlbumJSONResult.self, from: data)
                guard jsonData.resultCount != 0 else {
                    completion(.failure(.missingData))
                    return
                }
                let albums = jsonData.results.sorted { $0.albumName < $1.albumName }
                  let allAlbums = albums
                    for album in albums {
                        self?.loadImageData(for: album) { (data) in
                            DispatchQueue.main.async {
                                album.addImageData(data)
                                self?.dataUser?.dataEndLoading()
                            }
                        }
                    }
        
                  DispatchQueue.main.async {
                    completion(.success(allAlbums))
                  }
                } catch {
                    completion(.failure(.missingData))
                }
        }.resume()
    }
    
    private func loadImageData(for album: Album, with completion: @escaping (Data) -> Void) {
        guard let url = URL(string: album.albumImageLink) else { return }
        let _ = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
}
