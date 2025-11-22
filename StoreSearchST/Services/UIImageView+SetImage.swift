//
//  ArtworkImage.swift
//  StoreSearchST
//
//  Created by khamzaev on 13.11.2025.
//

import UIKit

extension UIImageView {
    func setImage(urlString: String?) {
        self.image = nil
        self.backgroundColor = UIColor.systemGray5
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true

        ImageLoader.shared.loadImage(from: urlString) { [weak self] image in
            guard let self = self, let image = image else { return }

            UIView.transition(
                with: self,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: {
                    self.image = image
                    self.backgroundColor = .clear
                })
        }
    }
}
