//
//  MovieInfoController.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/2/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

class MovieInfoController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    private let cellId = "cellId"
    var n = 1
    var isMovieType = ""
    
    
    var movie: Movie? {
        didSet {
            guard let posterURL = movie?.poster_path as String? else { return }
            let dateFormatter = DateFormatter()
            let finalDateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            finalDateFormatter.dateFormat = "yyyy"
            var toDate = Date()
            var dateString = ""
            
            if let movieName = movie?.original_title as String? {
                
                if let date = movie?.release_date {
                    toDate = dateFormatter.date(from: date as String)!
                    dateString = finalDateFormatter.string(from: toDate)
                    movieNameLabel.text = movieName + " (\(dateString))"
                }
                
            }
            
            if let tvShowName = movie?.original_name as String?{
                if let date = movie?.first_air_date {
                    toDate = dateFormatter.date(from: date as String)!
                    dateString = finalDateFormatter.string(from: toDate)
                    movieNameLabel.text = tvShowName + " (\(dateString))"
                }
            }
            
            if let movieSynopsis = movie?.overview as String? {
                self.synopsisLabel.text = movieSynopsis
            }
            
            if let mediaType = movie?.media_type as String? {
                typeLabel.text = "Media Type: " + mediaType
            }
            
            if let voteAverage = movie?.vote_average {
                ratingLabel.text = "Rating: " + "\(voteAverage) out of 10"
            }
            
            coverImage.downloadImageFrom(urlString: "https://image.tmdb.org/t/p/w500" + posterURL)
            blurredCoverImage.downloadImageFrom(urlString: "https://image.tmdb.org/t/p/w500" + posterURL)
        }
    }
    
    
    
    var movies = [Movie]()
    var castMembers = [Cast]()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: UIScreen.main.bounds)
        sv.isScrollEnabled = true
        sv.delegate = self
        return sv
    }()
    
    let coverImage: CoverImage = {
        let ci = CoverImage()
        ci.translatesAutoresizingMaskIntoConstraints = false
        ci.contentMode = .scaleAspectFill
        ci.clipsToBounds = true
        ci.image = UIImage(named: "nocover")
        return ci
    }()
    
    let blurredCoverImage: CoverImage = {
        let bci = CoverImage(frame: .zero)
        bci.translatesAutoresizingMaskIntoConstraints = false
        bci.contentMode = .scaleAspectFill
        bci.clipsToBounds = true
        return bci
    }()
    
    let movieNameLabel: UILabel = {
        let mnl = UILabel()
        mnl.translatesAutoresizingMaskIntoConstraints = false
        mnl.textColor = .white
        mnl.font = UIFont.boldSystemFont(ofSize: 17)
        return mnl
    }()
    
    let synopsisLabel: UILabel = {
        let sl = UILabel()
        sl.translatesAutoresizingMaskIntoConstraints = false
        sl.textColor = .white
        sl.font = UIFont.systemFont(ofSize: 16)
        return sl
    }()
    
    let ratingLabel: UILabel = {
        let sl = UILabel()
        sl.translatesAutoresizingMaskIntoConstraints = false
        sl.textColor = .white
        sl.font = UIFont.systemFont(ofSize: 16)
        return sl
    }()
    
    let typeLabel: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.textColor = .white
        tl.font = UIFont.systemFont(ofSize: 16)
        return tl
    }()
    
    let similarLabel: UILabel = {
        let sl = UILabel()
        sl.translatesAutoresizingMaskIntoConstraints = false
        sl.textColor = .white
        sl.font = UIFont.boldSystemFont(ofSize: 18)
        sl.text = "Similar Movies"
        return sl
    }()
    
    let castLabel: UILabel = {
        let sl = UILabel()
        sl.translatesAutoresizingMaskIntoConstraints = false
        sl.textColor = .white
        sl.font = UIFont.boldSystemFont(ofSize: 18)
        sl.text = "Cast"
        return sl
    }()
    
    let castCollectionView: CastController = {
        let l = UICollectionViewFlowLayout()
        let csv = CastController(collectionViewLayout: l)
        l.scrollDirection = .horizontal
        csv.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        return csv
    }()
    
    
    var collectionView: UICollectionView?
    var saveButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        fetchSimilarMovies()
        getCredits()
    }
    
    func setupComponents() {
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(saveMovie))
        self.navigationItem.rightBarButtonItem = saveButton
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.backgroundColor = .clear
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            
        }
        
        addBlur(toView: blurredCoverImage)
        view.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        view.insertSubview(blurredCoverImage, belowSubview: scrollView)
        scrollView.addSubview(coverImage)
        scrollView.addSubview(movieNameLabel)
        scrollView.addSubview(synopsisLabel)
        scrollView.addSubview(typeLabel)
        scrollView.addSubview(similarLabel)
        scrollView.addSubview(castLabel)
        scrollView.addSubview(ratingLabel)
        
        if let ccView = collectionView {
            scrollView.addSubview(ccView)
        }
        
        if let castCC = castCollectionView.collectionView {
            scrollView.addSubview(castCC)
        }
        
        if isMovieType == "tv" {
            similarLabel.text = "Similar Shows"
        }
        
        
        
        //add the constraints
        coverImage.widthAnchor.constraint(equalToConstant: 187.5).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: 281.25).isActive = true
        coverImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        coverImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80).isActive = true
        
        blurredCoverImage.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        blurredCoverImage.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        
        movieNameLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 8).isActive = true
        movieNameLabel.centerXAnchor.constraint(equalTo: coverImage.centerXAnchor).isActive = true
        movieNameLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.width - CGFloat(50)).isActive = true
        
        synopsisLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 8).isActive = true
        synopsisLabel.centerXAnchor.constraint(equalTo: coverImage.centerXAnchor).isActive = true
        synopsisLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.width - CGFloat(50)).isActive = true
        
        ratingLabel.topAnchor.constraint(equalTo: synopsisLabel.bottomAnchor, constant: 8).isActive = true
        ratingLabel.centerXAnchor.constraint(equalTo: coverImage.centerXAnchor).isActive = true
        ratingLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.width - CGFloat(50)).isActive = true
        
        typeLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8).isActive = true
        typeLabel.centerXAnchor.constraint(equalTo: coverImage.centerXAnchor).isActive = true
        typeLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.width - CGFloat(50)).isActive = true
        
        if typeLabel.text == "" {
            similarLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8).isActive = true
        }
        else {
            similarLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8).isActive = true
        }
        
        similarLabel.centerXAnchor.constraint(equalTo: coverImage.centerXAnchor).isActive = true
        similarLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.width - CGFloat(50)).isActive = true
        
        collectionView?.topAnchor.constraint(equalTo: similarLabel.bottomAnchor, constant: 8).isActive = true
        collectionView?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView?.heightAnchor.constraint(equalToConstant: 187.5).isActive = true
        collectionView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        castLabel.topAnchor.constraint(equalTo: (collectionView?.bottomAnchor)!, constant: 8).isActive = true
        castLabel.centerXAnchor.constraint(equalTo: coverImage.centerXAnchor).isActive = true
        castLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.width - CGFloat(50)).isActive = true
        
        castCollectionView.collectionView?.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 8).isActive = true
        castCollectionView.collectionView?.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        castCollectionView.collectionView?.heightAnchor.constraint(equalToConstant: 150).isActive = true
        castCollectionView.collectionView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    let ud = UserDefaults.standard
    
    @objc func saveMovie(sender: UITapGestureRecognizer) {
        // later
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        scrollView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 0, 0)
        scrollView.frame = view.bounds
        
        movieNameLabel.numberOfLines = 0
        movieNameLabel.textAlignment = .center
        
        synopsisLabel.numberOfLines = 0
        synopsisLabel.sizeToFit()
        synopsisLabel.textAlignment = .justified
        
        similarLabel.textAlignment = .center
        castLabel.textAlignment = .center
        
        ratingLabel.textAlignment = .left
        
        typeLabel.numberOfLines = 0
        typeLabel.sizeToFit()
        typeLabel.textAlignment = .left
        print(isMovieType)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MovieCell
        cell.movie = movies[indexPath.item]
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMoreInfo)))
        return cell
    }
    
    @objc func showMoreInfo(sender: UITapGestureRecognizer) {
        let movieInfoController = MovieInfoController()
        let touchLocation = sender.location(in: collectionView)
        guard let index = collectionView?.indexPathForItem(at: touchLocation) else { return }
        movieInfoController.movie = movies[index.item]
        movieInfoController.isMovieType = isMovieType
        self.navigationController?.pushViewController(movieInfoController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            return CGSize(width: collectionView.frame.width / 6, height: 187.5)
        }
        return CGSize(width: collectionView.frame.width / 3, height: 187.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func fetchSimilarMovies() {
        if let movieType = movie?.media_type {
            isMovieType = String(movieType)
        }
        guard let id = movie?.id else { return }
        let idToInt = id.intValue
        MovieAPIService.shared.similarMovies(withID: idToInt, isMovie: isMovieType, page: n) { (fetchedMovies: [Movie]) in
            DispatchQueue.main.async {
                self.movies = fetchedMovies
                self.collectionView?.reloadData()
            }
        }
    }
    
    var isRunning: Bool = false
    
    func getCredits() {
        if isRunning == false {
            if let movieType = movie?.media_type {
                isMovieType = String(movieType)
            }
            guard let id = movie?.id else { return }
            let idToInt = id.intValue
            MovieAPIService.shared.getCast(movieID: idToInt, isMovie: isMovieType) { (fetchedCastMembers: [Cast]) in
                self.castCollectionView.casts = fetchedCastMembers
                self.castCollectionView.collectionView?.reloadData()
                self.isRunning = true
            }
        }
    }
    
}
