//
//  WebService.swift
//  MovieDB
//
//  Created by Abdullah Onur Şimşek on 12.02.2022.
//

import Foundation
import Alamofire
import ObjectMapper

class WebService {
    private static let ApiKey : String = "726e15f3daf1de3b57996b8991c6e42f"
    
    private static var isReachable:Bool {
        get { return NetworkReachabilityManager()?.isReachable ?? false }
    }
    
    public static func checkReachability() -> Bool {
        if isReachable {
            return true
        }
        else {
            return false
        }
    }
    
    public static func getUpcomingMovies(page: Int,
                                         success: @escaping(UpcomingMovieModel)->(),
                                         fail: @escaping(String)->()) {
        if checkReachability() {
            let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=" + ApiKey + "&page=" + "\(page)"
            print(urlString)
            guard let url = URL(string: urlString)
            else {
                fail("Wrong URL")
                return
            }
                        
            AF.request(url, method: .get, parameters: nil ).responseJSON { response in
                guard let data = response.value as? [String:Any]
                else {
                    fail("Json Error")
                    return
                }
                
                if let model : UpcomingMovieModel = Mapper<UpcomingMovieModel>().map(JSON: data) {
                    success(model)
                }
                else {
                    fail("Object Mapping Error")
                }
            }
        }
        else {
            fail("Internet Connection Problem")
        }
    }
    
    public static func getMovieDetails(movieId: Int,
                                       success: @escaping(MovieDetailModel)->(),
                                       fail: @escaping(String)->()) {
        if checkReachability() {
            let urlString = "https://api.themoviedb.org/3/movie/" + "\(movieId)" + "?api_key=" + "\(ApiKey)"
            guard let url = URL(string: urlString)
            else {
                fail("Wrong URL")
                return
            }
            
            AF.request(url, method: .get, parameters: nil).responseJSON { response in
                guard let data = response.value as? [String:Any]
                else {
                    fail("Json Error")
                    return
                }
                
                if let model : MovieDetailModel = Mapper<MovieDetailModel>().map(JSON: data) {
                    success(model)
                }
                else {
                    fail("Object Mapping Error")
                }
            }
        }
        else {
            fail("Internet Connection Problem")
        }
    }
    
    public static func getSearchMovie(page : Int,
                                      searchText: String,
                                      success: @escaping(SearchMovieModel)->(),
                                      fail: @escaping(String)->()) {
        if checkReachability() {
            let urlString = "https://api.themoviedb.org/3/search/movie?api_key=" + "\(ApiKey)" + "&query=" + searchText + "&page=" + "\(page)" + "&include_adult=true"
            guard let url = URL(string: urlString)
            else {
                fail("Worng URL")
                return
            }
            
            AF.request(url, method: .get, parameters: nil).responseJSON { response in
                guard let data = response.value as? [String:Any]
                else {
                    fail("Json Error")
                    return
                }
                
                if let model : SearchMovieModel = Mapper<SearchMovieModel>().map(JSON: data) {
                    success(model)
                }
                else {
                    fail("Object Mapping Error")
                }
            }
        }
        else {
            fail("Internet Connection Problem")
        }
    }
    
    public static func getSimilarMovies(page : Int,
                                        id: Int,
                                        success: @escaping(SearchMovieModel)->(),
                                        fail: @escaping(String)->()) {
        if checkReachability() {
            let urlString = "https://api.themoviedb.org/3/movie/" + String(id) + "/similar?api_key=" + ApiKey + "&page=" + String(page)
            guard let url = URL(string: urlString)
            else {
                fail("Wrong URL")
                return
            }
            
            AF.request(url, method: .get, parameters: nil).responseJSON { response in
                guard let data = response.value as? [String:Any]
                else {
                    fail("Json Error")
                    return
                }
                
                if let model : SearchMovieModel = Mapper<SearchMovieModel>().map(JSON: data) {
                    success(model)
                }
                else {
                    fail("Object Mapping Error")
                }
            }
        }
        else {
            fail("Internet Connection Problem")
        }
    }
    
}
