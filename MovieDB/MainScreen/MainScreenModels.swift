//
//  Models.swift
//  MovieDB
//
//  Created by Abdullah Onur Şimşek on 12.02.2022.
//

import Foundation
import ObjectMapper

class UpcomingMovieModel: Mappable {
    var dates : DatesModel?
    var page : Int?
    var result : [MovieModel]?
    var totalPages : Int?
    var totalResult : Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        dates <- map["dates"]
        page <- map["page"]
        result <- map["results"]
        totalPages <- map["total_pages"]
        totalResult <- map["total_results"]
    }
}

class SearchMovieModel : Mappable {
    var page : Int?
    var results : [MovieModel]?
    var total_pages : Int?
    var total_results : Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        page <- map["page"]
        results <- map["results"]
        total_pages <- map["total_pages"]
        total_results <- map["total_results"]
    }
}

//MARK: - Submodels

class DatesModel: Mappable {
    var maximum : String?
    var minimum : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        maximum <- map["maximum"]
        minimum <- map["minimum"]
    }
}

class MovieModel: Mappable {
    var adult : Bool?
    var backdrop_path : String?
    var genre_ids : [Int]?
    var id : Int?
    var original_language : String?
    var original_title : String?
    var overview : String?
    var popularity : Double?
    var poster_path : String?
    var release_date : String?
    var title : String?
    var video : Bool?
    var vote_average : Double?
    var vote_count : Double?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        adult <- map["adult"]
        backdrop_path <- map["backdrop_path"]
        genre_ids <- map["genre_ids"]
        id <- map["id"]
        original_language <- map["original_language"]
        original_title <- map["original_title"]
        overview <- map["overview"]
        popularity <- map["popularity"]
        poster_path <- map["poster_path"]
        release_date <- map["release_date"]
        title <- map["title"]
        video <- map["video"]
        vote_average <- map["vote_average"]
        vote_count <- map["vote_count"]
    }
}


