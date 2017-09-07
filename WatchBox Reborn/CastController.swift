//
//  CastController.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/9/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CastController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var casts = [Cast()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(CastCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0)
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView?.backgroundColor = .clear
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CastCell
        cell.cast = casts[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showMovieCredits(atIndex: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 160)
    }
    
    func showMovieCredits(atIndex: IndexPath) {
        
        let castMovieFeedCo = CastMovieFeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let window = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        castMovieFeedCo.id = casts[atIndex.item].id
        castMovieFeedCo.navigationItem.title = casts[atIndex.item].name! as String
        
        window.pushViewController(castMovieFeedCo, animated: true)
        
    }
    
}
