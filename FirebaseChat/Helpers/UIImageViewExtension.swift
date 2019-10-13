//
//  UIImageViewExtension.swift
//  FirebaseChat
//
//  Created by Sergey on 10/13/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import Foundation
import UIKit

let imageCashe = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCasheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        if let cashedImage = imageCashe.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cashedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCashe.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
        }.resume()
        
    }
}
