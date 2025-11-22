//
//  DetailViewModel.swift
//  StoreSearchST
//
//  Created by khamzaev on 22.11.2025.
//

import Foundation
import AVFoundation

final class DetailViewModel {
    
    private let item: ITunesItem
    private var player: AVPlayer?
    
    var onPreviewStateChanged: ((Bool) -> Void)?
    
    init(item: ITunesItem) {
        self.item = item
    }
    
    var titleText: String {
        item.trackName ?? item.collectionName ?? "Unknown"
    }
    
    var subtitleText: String {
        item.artistName ?? ""
    }
    
    var genreText: String {
        item.primaryGenreName ?? "Unknown"
    }
    
    var typeText: String {
        mapKindToTypeName(item.kind)
    }
    
    var artworkURL: String? {
        item.artworkUrl100
    }
    
    var priceText: String {
        getPriceText(from: item)
    }
    
    func storeURL() -> URL? {
        if let urlString = item.trackViewUrl {
            return URL(string: urlString)
        }
        if let urlString = item.collectionViewUrl {
            return URL(string: urlString)
        }
        return nil
    }
    
    func togglePreview() {
        guard let urlString = item.previewUrl,
              let url = URL(string: urlString) else { return }
        
        if player == nil {
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            observePreviewEnd(for: playerItem)
        }
        
        if player?.timeControlStatus == .playing {
            player?.pause()
            onPreviewStateChanged?(false)
        } else {
            player?.play()
            onPreviewStateChanged?(true)
        }
    }
    
    func stopPreview() {
        player?.pause()
        player = nil
        onPreviewStateChanged?(false)
    }
    
    //MARK: - Helpers
    private func mapKindToTypeName(_ kind: String?) -> String {
        guard let kind = kind else { return "Unknown" }
        if kind.contains("song") { return "Song" }
        if kind.contains("album") { return "Album" }
        if kind.contains("music-video") { return "Music Video" }
        if kind.contains("movie") { return "Movie" }
        if kind.contains("software") { return "App" }
        if kind.contains("book") { return "Book" }
        if kind.contains("podcast") { return "Podcast" }
        
        return "Other"
    }
    
    private func getPriceText(from item: ITunesItem) -> String {
        if let formatted = item.formattedPrice, !formatted.isEmpty {
            return formatted
        }
        if let price = item.trackPrice {
            if price == 0 {
                return "FREE"
            }
            if let currency = item.currency {
                return "\(price) \(currency)"
            } else {
                return "\(price)"
            }
        }
        return "FREE"
    }
    
    private func observePreviewEnd(for playerItem: AVPlayerItem) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.stopPreview()
        }
    }
}
