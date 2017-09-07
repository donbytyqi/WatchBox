//
//  Extensions.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/2/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CoverImage: UIImageView {
    
    var coverImageURL: String?
    
    func downloadImageFrom(urlString: String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        coverImageURL = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        image = UIImage(named: "nocover")
        
        if let isCachedImage = imageCache.object(forKey: urlString as AnyObject) {
            self.image = isCachedImage as? UIImage
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        }
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error!)
            }
            
            DispatchQueue.main.async {
                guard let imageData = data else { return }
                let cachedImage = UIImage(data: imageData)
                
                if self.coverImageURL == urlString {
                    self.image = cachedImage
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                imageCache.setObject(cachedImage!, forKey: urlString as AnyObject)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
            
            }.resume()
        
    }
}

public func addBlur(toView: UIView) {
    let blurEffect = UIBlurEffect(style: .dark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = toView.bounds
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    toView.addSubview(blurView)
}

extension UIView
{
    func searchVisualEffectsSubview() -> UIVisualEffectView?
    {
        if let visualEffectView = self as? UIVisualEffectView
        {
            return visualEffectView
        }
        else
        {
            for subview in subviews
            {
                if let found = subview.searchVisualEffectsSubview()
                {
                    return found
                }
            }
        }
        
        return nil
    }
}


extension UISearchBar {
    func cancelButton(_ isEnabled: Bool) {
        for subview in self.subviews {
            for button in subview.subviews {
                if button.isKind(of: UIButton.self) {
                    let cancelButton = button as! UIButton
                    cancelButton.isEnabled = isEnabled
                }
            }
        }
    }
}

class Alert: NSObject {
    func show(title: String, message: String, controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
