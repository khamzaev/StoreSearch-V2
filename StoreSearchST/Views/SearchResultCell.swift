//
//  SearchResultCell.swift
//  StoreSearchST
//
//  Created by khamzaev on 08.11.2025.
//

import UIKit

final class SearchResultCell: UITableViewCell {
    static let reuseID = "SearchResultCell"
    
    private let icon = UIImageView()
    private let title = UILabel()
    private let subtitle = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        icon.layer.cornerRadius = 10
        icon.layer.masksToBounds = true 
        icon.image = UIImage(systemName: "music.note.list")
        icon.tintColor = .secondaryLabel
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 17, weight: .medium)
        title.textColor = .label
        title.numberOfLines = 1
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.font = .systemFont(ofSize: 14, weight: .regular)
        subtitle.textColor = .secondaryLabel
        subtitle.numberOfLines = 1
        
        contentView.addSubview(icon)
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        
        NSLayoutConstraint.activate([
            // иконка
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 60),
            icon.heightAnchor.constraint(equalToConstant: 60),
            
            // title (первая строка)
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // subtitle (вторая строка)
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            subtitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            subtitle.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            
            // нижний якорь
            subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        accessoryType = .none
        selectionStyle = .default
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with result: SearchResult) {
        title.text = result.title
        subtitle.text = result.subtitle
        icon.setImage(urlString: result.artworkURL)
    }
}
