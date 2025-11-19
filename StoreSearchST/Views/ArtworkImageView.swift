//
//  ArtworkImage.swift
//  StoreSearchST
//
//  Created by khamzaev on 13.11.2025.
//

import Foundation
import UIKit

private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func setImage(urlString: String?) {
        self.image = nil
        self.backgroundColor = UIColor.systemGray5
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return}
        if let cached = imageCache.object(forKey: urlString as NSString) {
            self.image = cached
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            
            imageCache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                UIView.transition(
                    with: self,
                    duration: 0.25,
                    options: .transitionCrossDissolve,
                    animations: {
                        self.image = image
                        self.backgroundColor = .clear
                    })
            }
        }.resume()
    }
}
