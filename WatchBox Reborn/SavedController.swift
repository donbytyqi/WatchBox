//
//  SavedController.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/12/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

class SavedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var savedMovies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let movieInfoController = MovieInfoController()
//        if movieInfoController.ud.object(forKey: "savedMoviesArray") != nil {
//            let savedMoviesArray = movieInfoController.ud.data(forKey: "savedMoviesArray")
//            let decoder = JSONDecoder()
//            let decodedObject = try? decoder.decode(Movie.self, from: savedMoviesArray!)
//            savedMovies = [decodedObject!]
//            self.collectionView?.reloadData()
//        }
        
        setupComponents()
    }
    
    func setupComponents() {
        collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMovies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCell
        cell.movie = savedMovies[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ? CGSize(width: collectionView.frame.width / 5, height: 187.5) : CGSize(width: collectionView.frame.width / 3, height: 187.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
