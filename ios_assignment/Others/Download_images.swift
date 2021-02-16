//
//  Download_images.swift
//  ios_assignment
//
//  Created by Sai Naveen Katla on 16/02/21.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString){
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
}
