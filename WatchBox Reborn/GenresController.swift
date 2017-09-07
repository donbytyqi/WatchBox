//
//  GenresController.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/3/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

protocol PickGenreDelegate {
    func genre(_ pickedGenre: Genre?, string: String)
}

class GenresController: UITableViewController {
    
    var genres: [String]?
    var keys: [String]?
    var didPickGenreDelegate: PickGenreDelegate?
    
    private let cellId = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        genres = ["Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Sci-Fi", "Sport", "Thriller", "War", "Western"]
        keys = ["28", "12", "16", "35", "80", "99", "18", "10751", "14", "36", "27", "10402", "9648", "10749", "878", "10770", "53", "10752", "37"]
        
        if genres?.count == keys?.count {
            print("equal")
        }
        
        tableView.reloadData()
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        cell?.textLabel?.text = genres?[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let k = keys?[indexPath.row] ?? "28"
        
        if didPickGenreDelegate != nil {
            didPickGenreDelegate?.genre(Genre(rawValue: k), string: (genres?[indexPath.row])!)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
