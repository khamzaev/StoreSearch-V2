//
//  NothingFoundCell.swift
//  StoreSearchST
//
//  Created by khamzaev on 10.11.2025.
//

import UIKit

final class NothingFoundCell: UITableViewCell {
    static let reuseID = "NothingFoundCell"
    
    private let icon = UIImageView()
    private let title = UILabel()
    private let subTitle = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
        icon.tintColor = .tertiaryLabel
        icon.image = UIImage(systemName: "magnifyingglass")
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Ничего не найдено"
        title.font = .systemFont(ofSize: 17, weight: .semibold)
        title.textColor = .secondaryLabel
        title.textAlignment = .center
        title.numberOfLines = 0
        
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.text = "Попробуйте изменить запрос"
        subTitle.font = .systemFont(ofSize: 14, weight: .regular)
        subTitle.textColor = .tertiaryLabel
        subTitle.textAlignment = .center
        subTitle.numberOfLines = 0
        
        contentView.addSubview(icon)
        contentView.addSubview(title)
        contentView.addSubview(subTitle)
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            icon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            subTitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            subTitle.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            
            subTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
}

