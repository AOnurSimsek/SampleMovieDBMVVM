//
//  DetailScreenViewController.swift
//  MovieDB
//
//  Created by Abdullah Onur Şimşek on 13.02.2022.
//

import UIKit
import SafariServices

class DetailScreenViewController: UIViewController {
    
    @IBOutlet weak var imdbButton: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overView: UILabel!
    
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var voteLabel: UILabel!
    
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var lanugageLabele: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var productionConturiesLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var viewModel = DetailScreenViewModel()
    var id : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        initUI()
        setGesture()
        getMovieDetail()
        setCollectionView()
    }
    
    func initViewModel(){
        viewModel.reloadView = {
            if let model = self.viewModel.getMovieDetailModel() {
                self.setView(model: model)
            }
            else {
                self.showAlert("Unknown Error Occured")
            }
        }
        viewModel.reloadCollectionView = {
            if self.viewModel.getSimilarMovies() != nil {
                self.collectionView.reloadData()
            }
            else {
                self.showAlert("Unknown Error Occured")
            }
        }
        viewModel.showError = {
            self.showAlert(self.viewModel.getErrorMessage())
        }
        viewModel.showLoading = {
            LoadingView.shared.startLoadingView(vc: self)
        }
        viewModel.hideLoading = {
            LoadingView.shared.stopLoadingView()
        }
    }
    
    func getMovieDetail(){
        if let unwrappedId = id {
            viewModel.fetchMovieDetail(id: unwrappedId)
        }
        else {
            self.showAlert("Unknown Error Occured")
        }
    }
    
    func initUI(){
        self.view.backgroundColor = .movieDBNavy
        self.navigationController?.navigationBar.backgroundColor = .movieDBNavy
        self.navigationController?.navigationBar.barTintColor  = .movieDBGreen
        self.navigationController?.navigationBar.tintColor = .movieDBGreen
        
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.shadowRadius = 14
        imageView.layer.shadowOpacity = 0.8
        imageView.clipsToBounds = false
        
        titleLabel.font = .systemFont(ofSize: 26, weight: .semibold)
        titleLabel.textColor = .movieDBGreen
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        overView.font = .systemFont(ofSize: 12, weight: .regular)
        overView.textColor = .lightText
        overView.textAlignment = .left
        overView.numberOfLines = 0
        
        starImage.image = UIImage(named: "star")
        starImage.tintColor = .goldYellow
        
        tagsLabel.numberOfLines = 0
        genreLabel.numberOfLines = 0
        productionConturiesLabel.numberOfLines = 0
    }
    
    func setView(model: MovieDetailModel){
        if let urlEndpoint = model.poster_path {
            imageView.sd_setImage(with: URL(string: String().getImageUrl(urlEndpoint))) { returnedImage, imageError, _, _ in
                if let averageColor = returnedImage?.averageColor {
                    self.imageView.layer.shadowColor = averageColor.cgColor
                }
                else {
                    self.imageView.layer.shadowColor = UIColor.movieDBBlue.cgColor
                }
            }
        }
        
        titleLabel.text = model.original_title
        
        overView.text = model.overview
        
        voteLabel.textColor = UIColor().getRatingColor(rating: (model.vote_average ?? 0.0))
        voteLabel.text = "\(model.vote_average ?? 0)" + " /10"
        
        imdbButton.image = UIImage(named: "imdb")
        imdbButton.layer.shadowColor = UIImage(named: "imdb")?.averageColor?.cgColor
        imdbButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        imdbButton.layer.shadowRadius = 6
        imdbButton.layer.shadowOpacity = 0.6
        imdbButton.clipsToBounds = false
        
       tagsLabel.attributedText = viewModel.getAttributedString(stringOne: "Tags : ", stringTwo: (model.tagline ?? ""))
        releaseDateLabel.attributedText = viewModel.getAttributedString(stringOne: "Release Date : ", stringTwo: (model.release_date ?? ""))
        runtimeLabel.attributedText = viewModel.getAttributedString(stringOne: "Runtime : ", stringTwo: "\(model.runtime ?? 0) minute")
        lanugageLabele.attributedText = viewModel.getAttributedString(stringOne: "Original Language : ", stringTwo: (model.original_language ?? ""))
        genreLabel.attributedText  = viewModel.getAttributedString(stringOne: "Genres : ", stringTwo: viewModel.getGenres(model: model.genres))
        productionConturiesLabel.attributedText =  viewModel.getAttributedString(stringOne: "Production Countries : ", stringTwo: viewModel.getCountries(model: model.production_countries))
    }
    
    func setGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imdbButtonPressed(_:)))
        self.imdbButton.addGestureRecognizer(gesture)
        self.imdbButton.isUserInteractionEnabled = true
    }
    
    @objc func imdbButtonPressed(_ sender: UITapGestureRecognizer){
        if let imdbId = viewModel.getImdbId() {
            let urlString = "https://www.imdb.com/title/" + imdbId
            guard let url = URL(string: urlString)
            else {
                self.showAlert("Something went terribly wrong. Please try again later.")
                return
            }
            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        else {
            self.showAlert("Something went terribly wrong. Please try again later.")
        }
    }
    

}

extension DetailScreenViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
        
    func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MovieDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MovieDetailCollectionViewCell.identifier)
        collectionView.backgroundColor = .movieDBNavy
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCellCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCollectionViewCell.identifier, for: indexPath) as! MovieDetailCollectionViewCell
        cell.model = viewModel.getCellData(index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailScreenViewController") as! DetailScreenViewController
        nextVC.id = viewModel.getCellData(index: indexPath.row)?.id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
