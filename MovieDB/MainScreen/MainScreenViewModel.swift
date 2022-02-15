//
//  MainScreenViewModel.swift
//  MovieDB
//
//  Created by Abdullah Onur Şimşek on 13.02.2022.
//

import Foundation

class MainScreenViewModel {
    
    private var upcomingDatas : UpcomingMovieModel? {
        didSet {
            self.changeViewtoUpcoming?()
        }
    }
    
    private var searchDatas : SearchMovieModel? {
        didSet {
            self.showEmptyView?()
        }
    }
    
    var reloadTableView: (()->())?
    var showError : (()->())?
    var showEmptyView : (()->())?
    var showLoading : (()->())?
    var hideLoading : (()->())?
    var changeViewtoSearch : (()->())?
    var changeViewtoUpcoming : (()->())?
    
    private var maxUpcomingMoviesPageSize : Int?
    private var maxSearchResultPageSize : Int?
    private var currentUpcomingMoviePage : Int?
    private var currentSearchMoviePage : Int?
    private var searchText : String?
    var errorMessage : String?
    var upcomingOrSearch : Bool = true
    // Control value for Main Screen. Will show if Upcoming movies if true or Search when false.
    
    
    
    func getUpcomingMovies(page: Int){
        showLoading?()
        WebService.getUpcomingMovies(page: page) { movies in
            self.upcomingOrSearch = true
            
            if page == 1 {
                self.upcomingDatas = movies
            }
            else {
                self.upcomingDatas?.result?.append(contentsOf: movies.result!)
            }
            self.maxUpcomingMoviesPageSize = movies.totalPages
            self.reloadTableView?()
            self.hideLoading?()
            self.currentUpcomingMoviePage = page
        } fail: { error in
            self.errorMessage = error
            self.showError?()
            self.hideLoading?()
        }
    }
    
    func searchMovie(page: Int,searchText: String ){
        showLoading?()

        self.searchText = searchText
        WebService.getSearchMovie(page: page, searchText: searchText) { searchedMovies in
            self.upcomingOrSearch = false
            
            if page == 1 {
                self.searchDatas = searchedMovies
            }
            else {
                guard let results = searchedMovies.results
                else {
                    self.showError?()
                    return
                }
                self.searchDatas?.results?.append(contentsOf: results)
            }
            self.maxSearchResultPageSize = searchedMovies.total_pages
            self.changeViewtoSearch?()
            self.reloadTableView?()
            self.hideLoading?()
            self.currentSearchMoviePage = page
        } fail: { error in
            self.errorMessage = error
            self.showError?()
            self.hideLoading?()
        }
    }
    
    func getNumberOfCells() -> Int {
        if upcomingOrSearch {
            return (upcomingDatas?.result?.count ?? 0)
        }
        else {
            return (searchDatas?.results?.count ?? 0)
        }
    }
    
    func getCellData(index: Int) -> MovieModel? {
        if upcomingOrSearch {
            guard let results = upcomingDatas?.result
            else {
                showError?()
                return nil
            }
            return results[index]
        }
        else {
            guard let results = searchDatas?.results
            else {
                showError?()
                return nil
            }
            return results[index]
        }
    }
    
    func getNextPage(){
        if upcomingOrSearch {
            if let maxPage = maxUpcomingMoviesPageSize, let currentPage = currentUpcomingMoviePage {
                if currentPage <= maxPage {
                    getUpcomingMovies(page: currentPage + 1)
                }
                else {
                    self.hideLoading?()
                }
            }
            else {
                self.hideLoading?()
            }
        }
        else {
            if let maxPage = maxSearchResultPageSize, let currentPage = currentSearchMoviePage, let searchText = self.searchText {
                if currentPage <= maxPage {
                    searchMovie(page: currentPage + 1, searchText: searchText)
                }
                else {
                    self.hideLoading?()
                }
            }
            else {
                self.hideLoading?()
            }
        }
    }
    
    func searchBarClosed(){
        searchText = ""
        upcomingOrSearch = true
        self.changeViewtoUpcoming?()
        self.reloadTableView?()
    }
    
}
