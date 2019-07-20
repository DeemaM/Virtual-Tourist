//
//  Customization.swift
//  Virtual Tourist
//
//  Created by Deema  on 17/07/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class Customization: UIImageView {
let imagesCache = NSCache<NSString, AnyObject>()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var imageURL: URL!
    
    func setPhoto(_ newPhoto: Photo) {

        photo = newPhoto
    }
    
    private var photo: Photo! {
        didSet {
            if let image = photo.getImage() {
                hideActivityIndicatorView()
                self.image = image
                return
            }
            
            guard let url = photo.imageURL else {
                return
            }
            
            loadImageUsingCache(with: url)
        }
    }
    
    func loadImageUsingCache(with url: URL) {
        imageURL = url
        image = nil
        showActivityIndicatorView()
        
        if let cachedImage = imagesCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
            hideActivityIndicatorView()
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let DownloadedImage = UIImage(data: data!) else { return }
            self.imagesCache.setObject(DownloadedImage, forKey:  url.absoluteString as NSString)
            DispatchQueue.main.async {
                self.image = DownloadedImage
                self.photo.set(image: DownloadedImage)
                ((try? self.photo.managedObjectContext?.save()) as ()??)
                self.hideActivityIndicatorView()
            }
            
            }.resume()
    }
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        self.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicatorView.color = .black
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    func showActivityIndicatorView() {
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func hideActivityIndicatorView() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
    }

}
