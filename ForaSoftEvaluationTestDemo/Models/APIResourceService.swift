//
//  APIResourceService.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/9/21.
//

import Foundation

protocol ApiResource {
    associatedtype ModelType: Decodable
    var parameters: [String: String] { get set }
}

struct Constants {
    static let itunesURL = "https://itunes.apple.com/search?"
}

extension ApiResource {
    var url: URL {
        let baseUrl = URL(string: Constants.itunesURL)!
        return baseUrl.appendingParameters(parameters)
    }
    
    mutating func addGroupName(_ name: String, to album: String) {
        let value = name + "+" + album
        self.parameters.updateValue(value, forKey: "term")
    }
}

struct AlbumsResource: ApiResource {
    typealias ModelType = [Album]
    var parameters: [String : String] = ["entity": "album", "attribute": "allArtistTerm"]
    
    mutating func addGroup(name: String) {
        self.parameters.updateValue(name, forKey: "term")
    }

}

struct SongsResource: ApiResource {
    typealias ModelType = [Song]
    var parameters: [String : String] = ["entity": "song", "attribute": "albumTerm", "limit": "100", "media":"music"]
    
    mutating func addAlbum(name: String) {
        self.parameters.updateValue(name, forKey: "term")
    }
}


extension URL {
    func appendingParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        var queryItems = urlComponents.queryItems ?? []
        for key in parameters.keys {
            queryItems.append(URLQueryItem(name: key, value: parameters[key]))
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
