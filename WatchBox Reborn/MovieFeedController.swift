//
//  ViewController.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/1/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

class MovieFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, PickGenreDelegate {
    
    func genre(_ pickedGenre: Genre?, string: String) {
        if let genre = pickedGenre {
            currentGenre = genre
            genreString = string
            self.movies?.removeAll()
            self.n = 1
            self.currentType = ""
            self.isMovie = "movies"
            MovieAPIService.shared.fetchMovies(isMovie: self.isMovie, page: self.n, type: self.currentType, genre: self.currentGenre , query: "") { (movies: [Movie]) in
                self.movies = movies
                self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
                self.collectionView?.reloadData()
            }
        }
    }
    
    private let cellID = "cellID"
    
    var movies: [Movie]?
    var n: Int = 1
    var currentType: String = "popular"
    var currentGenre: Genre? = .none
    var isMovie: String = "movie"
    var previousIsMovie: String = ""
    var titleType: String = "Movies"
    var genreString: String? = ""
    var isGenreView: Bool = false
    
    func fetchMovies() {
        MovieAPIService.shared.fetchMovies(isMovie: isMovie, page: n, type: currentType, query: "") { (movies: [Movie]) in
            self.movies = movies
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func fetchMoreMovies() {
        n += 1
        print(n)
        MovieAPIService.shared.fetchMovies(isMovie: isMovie, page: n , type: currentType, genre: currentGenre, query: "") { (movies: [Movie]) in
            for movie in movies {
                self.movies?.append(movie)
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        fetchMovies()
        previousIsMovie = isMovie
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MovieCell {
            cell.movie = movies?[indexPath.item]
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMoreInfo)))
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    @objc func showMoreInfo(sender: UITapGestureRecognizer) {
        let movieInfoController = MovieInfoController()
        let touchLocation = sender.location(in: collectionView)
        guard let index = collectionView?.indexPathForItem(at: touchLocation) else { return }
        movieInfoController.movie = movies?[index.item]
        if isMovie == "movies" {
            isMovie = "movie"
        }
        movieInfoController.isMovieType = isMovie
        self.navigationController?.pushViewController(movieInfoController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (movies?.count)! - 1 {
            fetchMoreMovies()
        }
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
    
    var menuButton: UIBarButtonItem?
    var searchButton: UIBarButtonItem?
    
    func setupComponents() {
        collectionView?.backgroundColor = .black
        collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: cellID)
        navigationItem.title = currentType.capitalized
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .blackTranslucent
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = (titleDict as! [String : Any])
        menuButton = UIBarButtonItem(image: UIImage(named: "menubar_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(handleMenuBar))
        navigationItem.leftBarButtonItem = menuButton
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        searchButton?.tintColor = .white
        navigationItem.rightBarButtonItem = searchButton
    }
    
    var isPopular: Bool = false
    
    @objc func handleMenuBar(sender: UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: "Change type", message: "Top rated, popular etc...", preferredStyle: .actionSheet)
        
        if let actionSheetSubview = actionSheet.view.searchVisualEffectsSubview() {
            actionSheetSubview.effect = UIBlurEffect(style: .dark)
        }
        
        actionSheet.view.tintColor = .white
        
        actionSheet.addAction(UIAlertAction(title: "Top rated", style: .default, handler: { (action) in
            self.movies?.removeAll()
            self.currentType = "top_rated"
            self.n = 1
            self.currentGenre = .none
            self.isMovie = self.previousIsMovie
            MovieAPIService.shared.fetchMovies(isMovie: self.isMovie, page: self.n, type: self.currentType, query: "") { (movies: [Movie]) in
                self.movies = movies
                
                DispatchQueue.main.async {
                    self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
                    self.collectionView?.reloadData()
                    self.genreString = ""
                    self.navigationItem.title = self.titleType.replacingOccurrences(of: " - ", with: "") + " - Top Rated"
                }
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Popular", style: .default, handler: { (action) in
            self.movies?.removeAll()
            self.currentType = "popular"
            self.n = 1
            self.currentGenre = .none
            self.isMovie = self.previousIsMovie
            MovieAPIService.shared.fetchMovies(isMovie: self.isMovie, page: self.n, type: self.currentType, query: "") { (movies: [Movie]) in
                self.movies = movies
                
                DispatchQueue.main.async {
                    self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
                    self.collectionView?.reloadData()
                    self.genreString = ""
                    self.navigationItem.title = self.titleType.replacingOccurrences(of: " - ", with: "") + " - Popular"
                }
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Movies", style: .default, handler: { (action) in
            self.movies?.removeAll()
            self.currentType = "popular"
            self.n = 1
            self.isMovie = "movie"
            self.previousIsMovie = self.isMovie
            self.currentGenre = .none
            MovieAPIService.shared.fetchMovies(isMovie: self.isMovie, page: self.n, type: self.currentType, query: "") { (movies: [Movie]) in
                self.movies = movies
                
                DispatchQueue.main.async {
                    self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
                    self.collectionView?.reloadData()
                    self.titleType = "Movies"
                    self.navigationItem.title = self.titleType
                }
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "TV Shows", style: .default, handler: { (action) in
            self.movies?.removeAll()
            self.currentType = "popular"
            self.n = 1
            self.isMovie = "tv"
            self.previousIsMovie = self.isMovie
            self.currentGenre = .none
            MovieAPIService.shared.fetchMovies(isMovie: self.isMovie, page: self.n, type: self.currentType, query: "") { (movies: [Movie]) in
                self.movies = movies
                
                DispatchQueue.main.async {
                    self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
                    self.collectionView?.reloadData()
                    self.titleType = "TV Shows"
                    self.navigationItem.title = self.titleType
                }
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Genres", style: .default, handler: { (action) in
            let genresController = GenresController(style: UITableViewStyle.plain)
            genresController.didPickGenreDelegate = self
            self.isGenreView = true
            self.navigationController?.pushViewController(genresController, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isGenreView == true {
            self.titleType = "Movies" + " - "
            self.navigationItem.title = self.titleType + self.genreString!
        }
    }
    
    @objc func handleSearch() {
        createSearchBar()
    }
    
    func createSearchBar() {
        let searchBar = UISearchBar()
        let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchBarTextField?.textColor = .white
        searchBar.placeholder = "Search for a movie..."
        searchBar.delegate = self
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.searchBarStyle = .minimal
        searchBar.cancelButton(true)
        searchBar.tintColor = .white
        searchBar.barTintColor = .white
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
    }
    
    func removeSearchBar() {
        navigationItem.titleView = nil
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = searchButton
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isMovie = self.previousIsMovie
        self.n = 1
        self.currentType = "popular"
        fetchMovies()
        removeSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.movies?.removeAll()
        let keyword = searchBar.text!
        let final = keyword.replacingOccurrences(of: " ", with: "+")
        MovieAPIService.shared.fetchMovies(page: 1, query: final) { (movies: [Movie]) in
            self.movies = movies
            self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            self.collectionView?.reloadData()
            searchBar.endEditing(true)
        }
    }
    
}
