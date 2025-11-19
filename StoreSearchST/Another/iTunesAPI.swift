//
//  iTunesService.swift
//  StoreSearchST
//
//  Created by khamzaev on 13.11.2025.
//

import Foundation

enum ITunesEntity: String {
    case all = ""
    case music = "musicTrack"
    case software = "software"
    case ebook = "ebook"
}

struct iTunesAPI {
    static func search(term: String, entity: ITunesEntity, completion: @escaping (Result<Data, Error>) -> Void) {
        let base = "https://itunes.apple.com/search"
        var components = URLComponents(string: base)!
        var queryItems: [URLQueryItem] = [
            .init(name: "term", value: term),
            .init(name: "limit", value: "50"),
            .init(name: "country", value: "US")
        ]
        if entity != .all {
            queryItems.append(.init(name: "entity", value: entity.rawValue))
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "BadUrl", code: 0)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
