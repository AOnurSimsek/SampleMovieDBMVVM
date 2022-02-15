//
//  MainScreenTableViewCell.swift
//  MovieDB
//
//  Created by Abdullah Onur Şimşek on 13.02.2022.
//

import UIKit
import SDWebImage

class MainScreenTableViewCell: UITableViewCell {
    
    static let identifier : String = "MainScreenTableViewCellIdentifier"
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePointLabel: UILabel!
    
    
    var model : MovieModel? {
        didSet {
            guard let unwrappedModel = model
            else {
                return
            }
            
            moviePointLabel.textColor = UIColor().getRatingColor(rating: (unwrappedModel.vote_average ?? 0.0))
            moviePointLabel.text = "\(unwrappedModel.vote_average ?? 0) /10"
            
            movieTitleLabel.text = (unwrappedModel.title ?? "" ) + "\n" + "(" + (unwrappedModel.release_date ?? "") + ")"
            
            let urlEndpoint = unwrappedModel.poster_path ?? ""
            
            cellImageView.sd_setImage(with: URL(string: String().getImageUrl(urlEndpoint))) { returnedImage, imageError, _, _ in
                if let averageColor = returnedImage?.averageColor {
                    self.cellImageView.layer.shadowColor = averageColor.cgColor
                }
                else {
                    self.cellImageView.layer.shadowColor = UIColor.movieDBBlue.cgColor
                }
            }
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initUI(){
        self.contentView.backgroundColor = .movieDBNavy
        
        movieTitleLabel.textColor = .textWhite
        movieTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        movieTitleLabel.textAlignment = .left
        movieTitleLabel.numberOfLines = 0
        
        moviePointLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        moviePointLabel.textAlignment = .center
        
        cellImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cellImageView.layer.shadowRadius = 14
        cellImageView.layer.shadowOpacity = 0.8
        cellImageView.clipsToBounds = false
    }
    
}
