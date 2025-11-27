//
//  SearchViewModel.swift
//  StoreSearchST
//
//  Created by khamzaev on 22.11.2025.
//

import Foundation

final class SearchViewModel {
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([SearchResult])
    }
    
    private(set) var state: State = .notSearchedYet {
        didSet {
            onStateChanged?(state)
        }
    }
    
    var onStateChanged: ((State) -> Void)?
    
    private let api: ITunesAPIProtocol
    
    init(api: ITunesAPIProtocol) {
        self.api = api
    }
    
    func performSearch(text: String, category: Category) {
        state = .loading
        
        let entity = mapCategoryToEntity(category)
        
        api.search(term: text, entity: entity) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.state = .noResults
            case .success(let data):
                self.handleData(data)
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
    
    private func handleData(_ data: Data) {
        do {
            let response = try JSONDecoder().decode(ITunesResponse.self, from: data)
            
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
        } catch {
            print("JSON ERROR:", error)
            self.state = .noResults
        }
    }
}
