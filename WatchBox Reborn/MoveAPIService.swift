//
//  MoveAPIService.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/1/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

enum Genre: String {
    case action = "28"
    case adventure = "12"
    case animation = "16"
    case comedy = "35"
    case crime = "80"
    case documentary = "99"
    case drama = "18"
    case family = "10751"
    case fantasy = "14"
    case history = "36"
    case horror = "27"
    case music = "10402"
    case mystery = "9648"
    case romance = "10749"
    case scienceFiction = "878"
    case tvMovie = "10770"
    case thriller = "53"
    case war = "10752"
    case western = "37"
    case none = ""
}

class MovieAPIService: NSObject {
    
    static let shared = MovieAPIService()
    
    var title: String?
    var year: String?
    var id = ""
    
    func fetchMovies(url: String? = "", isMovie: String? = "movie", page: Int, type: String? = "popular", genre: Genre? = .none, query: String?, completion: @escaping ([Movie]) -> ()) {
        var b = "https://api.themoviedb.org/3/"
        var t = type ?? "popular"
        var m = isMovie ?? "movie"
        var baseURL = b + m + "/" + t + "?api_key=087d599aa9589c52c4271a3eb196016e&language=en-US&page=\(page)"
        var stringToURL: URL?
        stringToURL = URL(string: baseURL)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if query != "" {
            let bb = "https://api.themoviedb.org/3/search/"
            baseURL = bb + "multi" + "?api_key=087d599aa9589c52c4271a3eb196016e&query=\(query!)&language=en-US&page=\(page)"
            print(baseURL)
            if let link = URL(string: baseURL) {
                stringToURL = link
                print(stringToURL!)
            }
        }
        
        if genre != .none {
            m = "movies"
            b = "https://api.themoviedb.org/3/genre/"
            t = type ?? "popular"
            baseURL = b + String(describing: (genre?.rawValue)!) + "/" + m + "?api_key=087d599aa9589c52c4271a3eb196016e&language=en-US&page=\(page)"
            print(baseURL)
            stringToURL = URL(string: baseURL)
        }
        
        URLSession.shared.dataTask(with: stringToURL!) { (data, response, error) in
            
            var movies = [Movie()]
            print(stringToURL!)
            if error != nil {
                self.showError(error as! String)
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                guard let results = jsonData["results"] as? NSArray else { return }
                
                for movie in 0..<results.count {
                    guard let movieDictionary = results[movie] as? [String : AnyObject] else { return }
                    let movie = Movie()
                    movie.setValuesForKeys(movieDictionary)
                    movies.insert(movie, at: movies.count - 1)
                }
                
                DispatchQueue.main.async {
                    completion(movies)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
            }
            catch {
                self.showError(error as! String)
            }
            
            
            }.resume()
    }
    
    func similarMovies(withID: Int, isMovie: String, page: Int, completion: @escaping ([Movie]) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/\(isMovie)/\(withID)/similar?api_key=087d599aa9589c52c4271a3eb196016e&language=en-US&page=\(page)")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            var movies = [Movie()]
            print(url!)
            if error != nil {
                self.showError(error as! String)
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                guard let results = jsonData["results"] as? NSArray else { return }
                
                for movie in 0..<results.count {
                    guard let movieDictionary = results[movie] as? [String : AnyObject] else { return }
                    let movie = Movie()
                    movie.setValuesForKeys(movieDictionary)
                    movies.insert(movie, at: movies.count - 1)
                }
                
                DispatchQueue.main.async {
                    completion(movies)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
            }
            catch {
                self.showError(error as! String)
            }
            
            
            }.resume()
    }
    
    func getCast(movieID: Int, isMovie: String, completion: @escaping ([Cast]) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/\(isMovie)/\(movieID)/credits?api_key=087d599aa9589c52c4271a3eb196016e")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            var casts = [Cast()]
            
            if error != nil {
                self.showError(error as! String)
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                guard let cast = jsonData["cast"] as? NSArray else { return }
                
                for i in 0..<cast.count {
                    guard let castDictionary = cast[i] as? [String : AnyObject] else { return }
                    let castClass = Cast()
                    castClass.setValuesForKeys(castDictionary)
                    casts.insert(castClass, at: casts.count - 1)
                }
                
                DispatchQueue.main.async {
                    completion(casts)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                }
                
            }
            catch {
                self.showError(error as! String)
            }
            
            
            }.resume()
    }
    
    func fetchCastMovies(byID: Int, isMovie: String, completion: @escaping ([Movie]) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/person/\(byID)/\(isMovie)_credits?api_key=087d599aa9589c52c4271a3eb196016e&language=en-US")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            var movies = [Movie()]
            print(url!)
            if error != nil {
                self.showError(error as! String)
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                guard let results = jsonData["cast"] as? NSArray else { return }
                
                for movie in 0..<results.count {
                    guard let movieDictionary = results[movie] as? [String : AnyObject] else { return }
                    let movie = Movie()
                    print(movieDictionary)
                    movie.setValuesForKeys(movieDictionary)
                    movies.insert(movie, at: movies.count - 1)
                }
                
                DispatchQueue.main.async {
                    completion(movies)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
            }
            catch {
                self.showError(error as! String)
            }
            
            
            }.resume()
    }
    
    func showError(_ error: String) {
        guard let window = UIApplication.shared.keyWindow else { return }
        Alert().show(title: "Something happened", message: error, controller: window.rootViewController!)
        return
    }
    
}

