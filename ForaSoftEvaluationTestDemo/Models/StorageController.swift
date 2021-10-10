//
//  StorageController.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/9/21.
//

import Foundation

enum StoreError: Error {
    case cantFetchData
    case saveDataFailure
}

class StorageController {
    private let cachesDirectoryURL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first!
    
    func save(history: HistoryData) {
        guard let storedData = fetchURLs() else {
            save(value: [history])
            return
        }
        var filteredStoreData = storedData.filter( { $0.groupName != history.groupName })
        filteredStoreData.append(history)
        save(value: filteredStoreData)
    }
    
    func fetchURLs() -> [HistoryData]? {
        return fetchData(of: [HistoryData].self)
    }
}

private extension StorageController {
    func fileUrl<T>(for type: T.Type) -> URL {
        let url = cachesDirectoryURL
            .appendingPathComponent(String(describing: type))
            .appendingPathExtension("plist")
        return url
    }
    
    private func getData(from url: URL) throws -> Data? {
        guard let plistData = try? Data(contentsOf: url) else {
            throw StoreError.cantFetchData
        }
        return plistData
    }
    
    func fetchData<V: Codable>(of type: V.Type) -> V? {
        do {
            let fileURL = fileUrl(for: type)
            let plistData = try getData(from: fileURL)
            let decoder = PropertyListDecoder()
            let data = try decoder.decode(V.self, from: plistData!)
            return data
        } catch {
            return nil
        }
    }
    
    func save<V: Codable> (value: V) {
        if let plistData = try? PropertyListEncoder().encode(value) {
            do {
                let fileURL = fileUrl(for: V.self)
                try plistData.write(to: fileURL)
            } catch {
                print("\(StoreError.saveDataFailure) error: \(error.localizedDescription)")
            }
        }
    }
}
