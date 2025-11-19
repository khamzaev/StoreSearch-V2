//
//  LoadingCell.swift
//  StoreSearchST
//
//  Created by khamzaev on 08.11.2025.
//

import UIKit

final class LoadingCell: UITableViewCell {
    static let reuseID = "LoadingCell"
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
        ])
        
        spinner.startAnimating()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
