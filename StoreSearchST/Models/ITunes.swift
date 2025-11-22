//
//  ITunesModels.swift
//  StoreSearchST
//
//  Created by khamzaev on 13.11.2025.
//

import Foundation

struct ITunesResponse: Decodable {
    let resultCount: Int
    let results: [ITunesItem]
}

struct ITunesItem: Decodable {
    let trackName: String?
    let collectionName: String?
    let artistName: String?
    let kind: String?
    let primaryGenreName: String?
    let artworkUrl100: String?
    let trackViewUrl: String?
    let collectionViewUrl: String?
    let formattedPrice: String?
    let trackPrice: Double?
    let currency: String?
    let previewUrl: String?
}
