//
//  DetailScreenViewModel.swift
//  MovieDB
//
//  Created by Abdullah Onur Şimşek on 13.02.2022.
//

import Foundation
import UIKit
import FirebaseAnalytics

class DetailScreenViewModel {

    private var similarMoviesModel : SearchMovieModel?
    private var movieDetailModel :  MovieDetailModel?
    private var errorMessage : String?

    var reloadView : (()->())?
    var reloadCollectionView : (()->())?
    var showError : (()->())?
    var showLoading : (()->())?
    var hideLoading : (()->())?
    
    func fetchSimilarMovies(id: Int){
        WebService.getSimilarMovies(page: 1, id: id) { moviesModel in
            self.similarMoviesModel = moviesModel
            self.reloadCollectionView?()
            self.hideLoading?()
        } fail: { errorString in
            self.errorMessage = errorString
            self.hideLoading?()
            self.showError?()
        }
    }
    
    func fetchMovieDetail(id: Int){
        showLoading?()
        WebService.getMovieDetails(movieId: id) { movieModel in
            self.movieDetailModel = movieModel
            self.reloadView?()
            self.fetchSimilarMovies(id: id)
            self.saveAnalytics()
        } fail: { errorString in
            self.errorMessage = errorString
            self.showError?()
        }

    }
    
    func getSimilarMovies() -> SearchMovieModel? {
        return similarMoviesModel
    }
    
    func getMovieDetailModel() -> MovieDetailModel? {
        return movieDetailModel
    }
    
    func getCellCount() -> Int {
        if let count = similarMoviesModel?.results?.count {
            return count
        }
        else {
            return 0
        }
    }
    
    func getImdbId() -> String? {
        if let id = movieDetailModel?.imdb_id {
            return id
        }
        else {
            return nil
        }
    }
    
    func getErrorMessage() -> String {
        if let message = errorMessage {
            return message
        }
        else {
            return "Unknown error occured. Please try again later."
        }
    }
    
    func getCellData(index: Int) -> MovieModel? {
        if let model = similarMoviesModel?.results {
            return model[index]
        }
        else {
            return nil
        }
    }
    
    func getAttributedString(stringOne: String, stringTwo:String) -> NSMutableAttributedString {
        if stringTwo == "" {
            let emptyAttributedString = NSMutableAttributedString(string: "Empty")
            return emptyAttributedString
        }
        else {
            let firstAttributedString = NSMutableAttributedString(string: stringOne)
            firstAttributedString.addAttribute(.foregroundColor, value: UIColor.movieDBGreen, range:NSRange(location: 0, length: stringOne.count))
            firstAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .medium), range: NSRange(location: 0, length: stringOne.count))
            let secondAttributedString = NSMutableAttributedString(string: stringTwo)
            secondAttributedString.addAttribute(.foregroundColor, value: UIColor.lightText, range:NSRange(location: 0, length: stringTwo.count))
            secondAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .regular), range: NSRange(location: 0, length: stringTwo.count))
            firstAttributedString.append(secondAttributedString)
            return firstAttributedString
        }
    }
    
    func getGenres(model : [GenreModel]?) -> String {
        var string : String = ""
        if let unwrappedModel  = model {
            for index in 0...unwrappedModel.count-1 {
                if index == 0 {
                    string = (unwrappedModel[index].name ?? "")
                }
                else {
                    string = string + ", " + (unwrappedModel[index].name ?? "")
                }
            }
            return string
        }
        else {
            return ""
        }
    }
    
    func getCountries(model : [CountryModel]?) -> String {
        var string : String = ""
        if let unwrappedModel  = model {
            if unwrappedModel.count != 0 {
                for index in 0...unwrappedModel.count-1 {
                    if index == 0 {
                        string = (unwrappedModel[index].name ?? "")
                    }
                    else {
                        string = string + ", " + (unwrappedModel[index].name ?? "")
                    }
                }
                return string
            }
            else {
                return ""
            }
        }
        else {
            return ""
        }
    }
    
    func saveAnalytics(){
        guard let unwrappedModel = movieDetailModel
        else {
            return
        }
        Analytics.logEvent("MovieDetail", parameters: [
            "MovieName" : (unwrappedModel.title ?? "") as NSObject,
            "MovieId" :  (unwrappedModel.id ?? 0) as NSObject,
            "MovieImdbId" : (unwrappedModel.imdb_id ?? "") as NSObject
        ])
    }
}
