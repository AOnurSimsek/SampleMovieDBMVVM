//
//  MovieDetailCollectionViewCell.swift
//  MovieDB
//
//  Created by Abdullah Onur Şimşek on 13.02.2022.
//

import UIKit

class MovieDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier : String = "MovieDetailCollectionViewCellIdentifier"
    
    @IBOutlet weak var imageView: UIImageView!
    
    var model : MovieModel? {
        didSet {
            guard let unwrappedModel = self.model
            else {
                return
            }
            
            let urlEndpoint = unwrappedModel.poster_path ?? ""
            
            imageView.sd_setImage(with: URL(string: String().getImageUrl(urlEndpoint))) { returnedImage, imageError, _, _ in
                if let averageColor = returnedImage?.averageColor {
                    self.imageView.layer.shadowColor = averageColor.cgColor
                }
                else {
                    self.imageView.layer.shadowColor = UIColor.movieDBBlue.cgColor
                }
            }
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setUI(){
        self.contentView.backgroundColor = .movieDBNavy
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.shadowRadius = 14
        imageView.layer.shadowOpacity = 0.8
        imageView.clipsToBounds = false
    }

}
