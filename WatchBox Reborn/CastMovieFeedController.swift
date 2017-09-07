//
//  CastMovieFeedController.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/11/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

class CastMovieFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var movies = [Movie]()
    var id: NSNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movies.removeAll()
        setupComponents()
        fetchCastMovieCredits(id: id as! Int)
    }
    
    func setupComponents() {
        collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCell
        cell.movie = movies[indexPath.item]
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
    
    func fetchCastMovieCredits(id: Int) {
        MovieAPIService.shared.fetchCastMovies(byID: id, isMovie: "movie") { (fetchedMovies: [Movie]) in
            self.movies = fetchedMovies
            self.collectionView?.reloadSections(IndexSet(integer: 0))
            print(self.movies.count)
        }
        MovieAPIService.shared.fetchCastMovies(byID: id, isMovie: "tv") { (fetchedMovies: [Movie]) in
            for movie in fetchedMovies {
                self.movies.append(movie)
            }
            self.collectionView?.reloadSections(IndexSet(integer: 0))
            print(self.movies.count)
        }
    }
    
}
