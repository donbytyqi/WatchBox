//
//  Movie.swift
//  WatchBox Reborn
//
//  Created by Don Bytyqi on 5/1/17.
//  Copyright © 2017 Don Bytyqi. All rights reserved.
//

import UIKit

class Movie: NSObject {
    
    var poster_path: NSString?
    var adult: Bool = false
    var overview: NSString?
    var release_date: NSString?
    var genre_ids: NSArray?
    var id: NSNumber?
    var original_title: NSString?
    var original_language: NSString?
    var title: NSString?
    var backdrop_path: NSString?
    var popularity: NSNumber?
    var vote_count: NSNumber?
    var video: Bool = false
    var vote_average: NSNumber?
    var first_air_date: NSString?
    var origin_country: NSArray?
    var name: NSString?
    var original_name: NSString?
    var media_type: NSString?
    var profile_path: NSString?
    var known_for: NSString?
    var character: NSString?
    var credit_id: NSString?
    var episode_count: NSString?
    
}


class Cast: NSObject {
    
    var cast_id: NSNumber?
    var character: NSString?
    var credit_id: NSString?
    var id: NSNumber?
    var name: NSString?
    var order: NSNumber?
    var profile_path: NSString?
    var gender: NSString?
    
}
