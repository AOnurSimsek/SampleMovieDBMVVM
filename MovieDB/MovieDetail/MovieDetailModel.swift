//
//  MovieDetailModel.swift
//  MovieDB
//
//  Created by Abdullah Onur Şimşek on 12.02.2022.
//

import Foundation
import ObjectMapper


class MovieDetailModel : Mappable {
    var adult : Bool?
    var backdrop_path : String?
    var belongs_to_collection : Bool?
    var budget : Int?
    var genres : [GenreModel]?
    var homepage : String?
    var id : Int?
    var imdb_id : String?
    var original_language : String?
    var original_title : String?
    var overview : String?
    var popularity : Double?
    var poster_path :String?
    var production_companies : [CompanyModel]?
    var production_countries : [CountryModel]?
    var release_date : String?
    var revenue : Int?
    var runtime : Int?
    var spoken_languages : [LanguageModel]?
    var status : String?
    var tagline : String?
    var title : String?
    var video : Bool?
    var vote_average : Double?
    var vote_count : Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        adult <- map["adult"]
        backdrop_path <- map["backdrop_path"]
        belongs_to_collection <- map["belongs_to_collection"]
        budget <- map["budget"]
        genres <- map["genres"]
        homepage <- map["homepage"]
        id <- map["id"]
        imdb_id <- map["imdb_id"]
        original_language <- map["original_language"]
        original_title <- map["original_title"]
        overview <- map["overview"]
        popularity <- map["popularity"]
        poster_path <- map["poster_path"]
        production_companies <- map["production_companies"]
        production_countries <- map["production_countries"]
        release_date <- map["release_date"]
        revenue <- map["revenue"]
        runtime <- map["runtime"]
        spoken_languages <- map["spoken_languages"]
        status <- map["status"]
        tagline <- map["tagline"]
        title <- map["title"]
        video <- map["video"]
        vote_average <- map["vote_average"]
        vote_count <- map["vote_count"]
    }
}

//MARK: - Submodels

class GenreModel : Mappable {
    var id : Int?
    var name : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
    
}

class CompanyModel : Mappable {
    var id : Int?
    var logo_path : String?
    var name : String?
    var origin_country : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        logo_path <- map["logo_path"]
        name <- map["name"]
        origin_country <- map["origin_country"]
    }
    
    
}

class CountryModel : Mappable {
    var iso_3166_1 : String?
    var name : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        iso_3166_1 <- map["iso_3166_1"]
        name <- map["name"]
    }
    
    
}

class LanguageModel : Mappable {
    var english_name : String?
    var iso_639_1 : String?
    var name : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
    }
    
    
}
