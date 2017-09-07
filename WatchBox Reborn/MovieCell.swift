//
//  MovieCell.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/1/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

class MovieCell: BaseCell {
    
    var movie: Movie? {
        didSet {
            guard let posterURL = movie?.poster_path as String? else { return }
            
            if let movieName = movie?.original_title as String? {
                movieNameLabel.text = movieName
            }
            
            if let tvShowName = movie?.original_name as String?{
                movieNameLabel.text = tvShowName
            }
            
            coverImage.downloadImageFrom(urlString: "https://image.tmdb.org/t/p/w500" + posterURL)
        }
    }
    
    let coverImage: CoverImage = {
        let ci = CoverImage()
        ci.translatesAutoresizingMaskIntoConstraints = false
        ci.contentMode = .scaleAspectFill
        ci.clipsToBounds = true
        return ci
    }()
    
    let blurredView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let bv = UIVisualEffectView(effect: blurEffect)
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    let movieNameLabel: UILabel = {
        let mnl = UILabel()
        mnl.translatesAutoresizingMaskIntoConstraints = false
        mnl.textColor = .white
        mnl.font = UIFont.systemFont(ofSize: 12)
        mnl.backgroundColor = .clear
        return mnl
    }()
    
    override func setupComponents() {
        
        backgroundColor = .black
        addSubview(coverImage)
        addSubview(blurredView)
        blurredView.contentView.addSubview(movieNameLabel)
        
        coverImage.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        coverImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        movieNameLabel.centerXAnchor.constraint(equalTo: blurredView.centerXAnchor).isActive = true
        movieNameLabel.widthAnchor.constraint(equalTo: blurredView.widthAnchor).isActive = true
        movieNameLabel.centerYAnchor.constraint(equalTo: blurredView.centerYAnchor).isActive = true
        movieNameLabel.heightAnchor.constraint(equalTo: blurredView.heightAnchor).isActive = true
        
        blurredView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        blurredView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        blurredView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieNameLabel.numberOfLines = 0
        movieNameLabel.adjustsFontSizeToFitWidth = true
        movieNameLabel.textAlignment = .center
    }
    
}
