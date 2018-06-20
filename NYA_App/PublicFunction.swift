//
//  PublicFunction.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 21/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

enum AppStoryboard : String {
    case Main, Home, Signup,User,NewFeed
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

extension UIViewController
{
    func showAlert (title : String , message : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        OperationQueue.main.addOperation {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func gotoTabbarController (storyBoardID : String)
    {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        controller.selectedIndex = 2
        self.present(controller, animated: true, completion:nil)
    }
}

// convert images into base64 and keep them into string

func convertImageToBase64(image: UIImage) -> String {
    
    var imageData = UIImagePNGRepresentation(image)
    let base64String = imageData?.base64EncodedString(options: .lineLength64Characters)
    return base64String!
    
}// end convertImageToBase64


extension UIImageView
{
    func setimage(url_string : String)
    {
        print("URL String:::::",url_string)
        self.sd_setImage(with: URL(string: "\(url_string)"), placeholderImage: #imageLiteral(resourceName: "image_placeholder"), options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
            if error != nil {
                print("Failed: \(error)")
                
            } else {
                print("Success")
            }
        }
    }
    
    func setUserimage(url_string : String)
    {
        print("URL String:::::",url_string)
        self.sd_setImage(with: URL(string: "\(url_string)"), placeholderImage: #imageLiteral(resourceName: "user"), options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
            if error != nil {
                print("Failed: \(error)")
                
            } else {
                print("Success")
            }
        }
    }
    
    
}

extension UIImage
{
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}




