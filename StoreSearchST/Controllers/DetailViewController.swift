//
//  DetailViewController.swift
//  StoreSearchST
//
//  Created by khamzaev on 17.11.2025.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    
    var item: ITunesItem?
    private var player: AVPlayer?
    private let cardView = UIView()
    private let artworkImageView = UIImageView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let genreLabel = UILabel()
    private let typeLabel = UILabel()
    
    private let previewButton = UIButton(type: .system)
    private let priceButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        cardView.backgroundColor = UIColor.systemBackground
        cardView.layer.cornerRadius = 20
        cardView.layer.masksToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            cardView.heightAnchor.constraint(equalToConstant: 330)
        ])
        
        artworkImageView.translatesAutoresizingMaskIntoConstraints = false
        artworkImageView.contentMode = .scaleAspectFit
        artworkImageView.layer.cornerRadius = 12
        artworkImageView.layer.masksToBounds = true
        artworkImageView.backgroundColor = UIColor.systemGray5
        
        cardView.addSubview(artworkImageView)
        
        NSLayoutConstraint.activate([
            artworkImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            artworkImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            artworkImageView.widthAnchor.constraint(equalToConstant: 120),
            artworkImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .label
        
        cardView.addSubview(titleLabel)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textColor = .secondaryLabel
        
        cardView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
        ])
        
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.font = .systemFont(ofSize: 14, weight: .regular)
        genreLabel.text = "Genre: \(item?.primaryGenreName ?? "Unknown")"
        genreLabel.textColor = .secondaryLabel
        genreLabel.textAlignment = .left
        genreLabel.numberOfLines = 1
        
        cardView.addSubview(genreLabel)
        
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        typeLabel.text = "Type: \(mapKindToTypeName(item?.kind))"
        typeLabel.textAlignment = .left
        typeLabel.textColor = .secondaryLabel
        typeLabel.numberOfLines = 1

        cardView.addSubview(typeLabel)
        
        NSLayoutConstraint.activate([
            // Type
            typeLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            typeLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            typeLabel.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),

            // Genre
            genreLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor)
        ])
        
        
        priceButton.translatesAutoresizingMaskIntoConstraints = false
        priceButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        priceButton.backgroundColor = UIColor(red: 0.17, green: 0.42, blue: 0.34, alpha: 1.0)
        priceButton.addTarget(self, action: #selector(openInStore), for: .touchUpInside)
        priceButton.tintColor = .white
        priceButton.layer.cornerRadius = 12
        priceButton.layer.masksToBounds = true
        priceButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)

        cardView.addSubview(priceButton)
        
        NSLayoutConstraint.activate([
            priceButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            priceButton.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 12)
        ])
        
        previewButton.translatesAutoresizingMaskIntoConstraints = false
        previewButton.configuration = nil
        previewButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        previewButton.tintColor = .white
        previewButton.imageView?.contentMode = .scaleAspectFit
        previewButton.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0)
        previewButton.layer.cornerRadius = 10
        previewButton.layer.masksToBounds = true
        previewButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        previewButton.addTarget(self, action: #selector(togglePreview), for: .touchUpInside)
        
        cardView.addSubview(previewButton)
        
        NSLayoutConstraint.activate([
            previewButton.centerYAnchor.constraint(equalTo: priceButton.centerYAnchor),
            previewButton.trailingAnchor.constraint(equalTo: priceButton.leadingAnchor, constant: -10),

            previewButton.leadingAnchor.constraint(greaterThanOrEqualTo: cardView.leadingAnchor, constant: 16)
        ])

        
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = UIColor(white: 0.3, alpha: 0.8)
        closeButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)

        cardView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configure(with item: ITunesItem) {
        self.item = item

        artworkImageView.setImage(urlString: item.artworkUrl100)
        titleLabel.text = item.trackName ?? item.collectionName ?? "Unknown"
        subtitleLabel.text = item.artistName ?? ""
        typeLabel.text = mapKindToTypeName(item.kind)
        genreLabel.text = item.primaryGenreName
        
        if let preview = item.previewUrl, !preview.isEmpty {
            previewButton.isHidden = false
        } else {
            previewButton.isHidden = true
        }
        
        priceButton.setTitle(getPriceText(from: item), for: .normal)
    }
    
    private func mapKindToTypeName(_ kind: String?) -> String {
        guard let kind = kind else { return "unknown"}
        
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
    
    private func getStoreURL(from item: ITunesItem) -> URL? {
        if let urlString = item.trackViewUrl, let url = URL(string: urlString) {
            return url
        }
        if let urlString = item.collectionViewUrl, let url = URL(string: urlString) {
            return url
        }
        return nil
    }
    
    @objc private func closePopup() {
        player?.pause()
        player = nil
        dismiss(animated: true)
    }
    
    @objc private func openInStore() {
        guard let item = item,
              let url = getStoreURL(from: item) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    @objc private func togglePreview() {
        guard let urlString = item?.previewUrl,
              let url = URL(string: urlString) else { return}
        
        if player == nil {
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            observePreviewEnd(for: playerItem)
        }
        
        if player?.timeControlStatus == .playing {
            player?.pause()
            previewButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            previewButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    private func observePreviewEnd(for playerItem: AVPlayerItem) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { [weak self] _ in
            guard let self = self else { return}
            
            self.player?.pause()
            self.player?.seek(to: .zero)
            self.previewButton.setTitle("Preview", for: .normal)
        }
    }
}
