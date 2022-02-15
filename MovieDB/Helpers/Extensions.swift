//
//  Extensions.swift
//  MovieDB
//
//  Created by Abdullah Onur Şimşek on 13.02.2022.
//

import Foundation
import UIKit

extension String {
    func getImageUrl(_ urlEndpoint:String) -> String {
        return "https://image.tmdb.org/t/p/w500/" + urlEndpoint
    }
}

extension UIViewController {
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func makeShadow() {
        self.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func getRatingColor(rating : Double) -> UIColor {
        if rating > 7.0 {
            return .voteGreen
        }
        else if rating > 4.0 {
            return .voteOrange
        }
        else {
            return .voteRed
        }
    }
    
    @nonobjc class var borderGray : UIColor {
        return UIColor(hexString: "3A4750")
    }
    @nonobjc class var mainBlue : UIColor {
        return UIColor(hexString: "2185D5")
    }
    @nonobjc class var backgroundBlack : UIColor {
        return UIColor(hexString: "303841")
    }
    @nonobjc class var textWhite : UIColor {
        return UIColor(hexString: "F3F3F3")
    }
    @nonobjc class var voteRed : UIColor {
        return UIColor(hexString: "D32626")
    }
    @nonobjc class var voteOrange : UIColor {
        return UIColor(hexString: "F5A31A")
    }
    @nonobjc class var voteGreen : UIColor {
        return UIColor(hexString: "79D70F")
    }
    @nonobjc class var movieDBNavy : UIColor {
        return UIColor(hexString: "0d253f")
    }
    @nonobjc class var movieDBGreen : UIColor {
        return UIColor(hexString: "90cea1")
    }
    @nonobjc class var movieDBBlue : UIColor {
        return UIColor(hexString: "01b4e4")
    }
    @nonobjc class var goldYellow : UIColor {
        return UIColor(hexString: "FFD700")
    }
    
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
