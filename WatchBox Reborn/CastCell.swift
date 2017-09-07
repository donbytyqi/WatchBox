//
//  CastCell.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/9/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

class CastCell: BaseCell {
    
    var cast: Cast? {
        didSet {
            if let castImage = cast?.profile_path {
                coverImage.downloadImageFrom(urlString: "https://image.tmdb.org/t/p/w500" + (castImage as String) as String)
            }
            
            if let realNameString = cast?.name {
                realNameLabel.text = realNameString as String
            }
            
            if let charNameString = cast?.character  {
                charNameLabel.text = charNameString as String
            }
        }
    }
    
    let coverImage: CoverImage = {
        let ci = CoverImage()
        ci.translatesAutoresizingMaskIntoConstraints = false
        ci.contentMode = .scaleAspectFill
        ci.clipsToBounds = true
        return ci
    }()
    
    let realNameLabel: UILabel = {
        let cnl = UILabel()
        cnl.translatesAutoresizingMaskIntoConstraints = false
        cnl.textColor = .white
        cnl.font = UIFont.systemFont(ofSize: 12)
        cnl.backgroundColor = .clear
        return cnl
    }()
    
    let charNameLabel: UILabel = {
        let cnl = UILabel()
        cnl.translatesAutoresizingMaskIntoConstraints = false
        cnl.textColor = UIColor(white: 1, alpha: 0.7)
        cnl.font = UIFont.systemFont(ofSize: 11)
        cnl.backgroundColor = .clear
        return cnl
    }()
    
    override func setupComponents() {
        
        backgroundColor = .clear
        addSubview(coverImage)
        addSubview(realNameLabel)
        addSubview(charNameLabel)
        
        coverImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        coverImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        realNameLabel.widthAnchor.constraint(equalTo: coverImage.widthAnchor).isActive = true
        realNameLabel.centerXAnchor.constraint(equalTo: coverImage.centerXAnchor).isActive = true
        realNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        realNameLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor).isActive = true
        
        charNameLabel.widthAnchor.constraint(equalTo: realNameLabel.widthAnchor).isActive = true
        charNameLabel.centerXAnchor.constraint(equalTo: realNameLabel.centerXAnchor).isActive = true
        charNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        charNameLabel.topAnchor.constraint(equalTo: realNameLabel.bottomAnchor, constant: -5).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImage.layer.cornerRadius = coverImage.frame.width / 2
        
        realNameLabel.textAlignment = .center
        realNameLabel.numberOfLines = 0
        
        charNameLabel.textAlignment = .center
        charNameLabel.numberOfLines = 0
        
    }
    
    
}
