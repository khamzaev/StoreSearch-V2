//
//  Search.swift
//  StoreSearchST
//
//  Created by khamzaev on 08.11.2025.
//

import Foundation

final class Search {
    
    enum Category {
        case all
        case music
        case software
        case ebook
    }
    
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([SearchResult])
    }
    
    private(set) var state: State = .notSearchedYet
    
    func performSearch(for text: String, category: Category, completion: @escaping (Bool) -> Void) {
        state = .loading
        
        iTunesAPI.search(term: text, entity: mapCategoryToEntity(category)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                completion(false)
            case .success(let data):
                self.handleSearchResponse(data, completion: completion)
            }
        }
    }
    
    private func mapCategoryToEntity(_ category: Category) -> ITunesEntity {
        switch category {
        case .all: return .all
        case .music: return .music
        case .software: return .software
        case .ebook: return .ebook
        }
    }
    
    private func handleSearchResponse(_ data: Data, completion: @escaping (Bool) -> Void) {
        do {
            let response = try JSONDecoder().decode(ITunesResponse.self, from: data)
            if let first = response.results.first {
                print("⚠️ JSON PRICE DEBUG:",
                      "formattedPrice =", first.formattedPrice as Any,
                      "trackPrice =", first.trackPrice as Any,
                      "currency =", first.currency as Any)
            }
            
            if response.results.isEmpty {
                self.state = .noResults
            } else {
                let mapped = response.results.map { item in
                    SearchResult(
                        title: item.trackName ?? item.collectionName ?? "No title",
                        subtitle: item.artistName ?? "",
                        artworkURL: item.artworkUrl100,
                        item: item
                    )
                }
                self.state = .results(mapped)
            }
            
            completion(true)
        } catch {
            print("JSON ERROR:", error)
            completion(false)
        }
    }
}

