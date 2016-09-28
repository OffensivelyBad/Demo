//
//  UIImageViewExtension.swift
//  Demo
//
//  Created by Shawn Roller on 9/27/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import Foundation

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, downloaded: @escaping (_ success: Bool) -> Void) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                downloaded(true)
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, downloaded: @escaping (_ downloaded: Bool) -> Void) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode) { (success) in
            downloaded(true)
        }
    }
}
