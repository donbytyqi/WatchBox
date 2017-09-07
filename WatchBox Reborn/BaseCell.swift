//
//  BaseCell.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/1/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

// To remove that annoying coder error

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    func setupComponents() {
        //add subviews to cell or things like that here
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
