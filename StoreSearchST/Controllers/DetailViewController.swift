//
//  DetailViewController.swift
//  StoreSearchST
//
//  Created by khamzaev on 17.11.2025.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel!
    
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
        
        setupCardView()
        setupArtwork()
        setupLabels()
        setupButtons()
        configure()
        
        viewModel.onPreviewStateChanged = { [weak self] isPlaying in
            guard let self = self else { return }
            let imageName = isPlaying ? "pause.fill" : "play.fill"
            self.previewButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    // MARK: - Setup UI
    private func setupCardView() {
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
    }
    
    private func setupArtwork() {
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
    }
    
    private func setupLabels() {
        // title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .label
        
        cardView.addSubview(titleLabel)
        // subtitle
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textColor = .secondaryLabel
        
        cardView.addSubview(subtitleLabel)
        // genre
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.font = .systemFont(ofSize: 14, weight: .regular)
        genreLabel.text = "Genre: \(viewModel.genreText)"
        genreLabel.textColor = .secondaryLabel
        genreLabel.textAlignment = .left
        genreLabel.numberOfLines = 1
        
        cardView.addSubview(genreLabel)
        // type
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        typeLabel.text = "Type: \(viewModel.typeText)"
        typeLabel.textAlignment = .left
        typeLabel.textColor = .secondaryLabel
        typeLabel.numberOfLines = 1

        cardView.addSubview(typeLabel)
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            // Type
            typeLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            typeLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            typeLabel.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),

            // Genre
            genreLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor)
        ])
    }
    
    private func setupButtons() {
        // Price
        priceButton.translatesAutoresizingMaskIntoConstraints = false
        priceButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        priceButton.backgroundColor = UIColor(red: 0.17, green: 0.42, blue: 0.34, alpha: 1.0)
        priceButton.addTarget(self, action: #selector(openInStore), for: .touchUpInside)
        priceButton.tintColor = .white
        priceButton.layer.cornerRadius = 12
        priceButton.layer.masksToBounds = true
        priceButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)

        cardView.addSubview(priceButton)
        
        // Close
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = UIColor(white: 0.3, alpha: 0.8)
        closeButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)

        cardView.addSubview(closeButton)
        
        // Preview
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
            // price
            priceButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            priceButton.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 12),
            // close
            closeButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28),
            // preview
            previewButton.centerYAnchor.constraint(equalTo: priceButton.centerYAnchor),
            previewButton.trailingAnchor.constraint(equalTo: priceButton.leadingAnchor, constant: -10),
            previewButton.leadingAnchor.constraint(greaterThanOrEqualTo: cardView.leadingAnchor, constant: 16)
        ])
    }
    
    // MARK: - Configure
    func configure() {
        artworkImageView.setImage(urlString: viewModel.artworkURL)
        titleLabel.text = viewModel.titleText
        subtitleLabel.text = viewModel.subtitleText
        typeLabel.text = viewModel.typeText
        genreLabel.text = viewModel.genreText

        priceButton.setTitle(viewModel.priceText, for: .normal)

        previewButton.isHidden = (viewModel.artworkURL == nil)
    }
    // MARK: - Actions
    @objc private func closePopup() {
        viewModel.stopPreview()
        dismiss(animated: true)
    }
    
    @objc private func openInStore() {
        if let url = viewModel.storeURL() {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func togglePreview() {
        viewModel.togglePreview()
    }
}
