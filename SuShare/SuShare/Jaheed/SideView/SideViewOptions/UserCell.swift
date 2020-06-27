//
//  UserCell.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Kingfisher

class UserCell: UITableViewCell {

    @IBOutlet weak var sideViewImage: UIImageView!
    @IBOutlet weak var sideViewUsername: UILabel!
    
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        updateUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    //let user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
        //imageSetup()
    }
    
    private func updateUI(){
        guard let user = Auth.auth().currentUser,
//            let url = user.photoURL,
            let displayName = user.displayName
        else {
            print("this is not working")
            return
        }
        
        
//        sideViewImage?.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (result) in
//            switch result {
//            case .failure(let kingFisherError):
//              print("this isnt working\(kingFisherError)")
//            case .success(let success):
//                print("this works \(success)")
//            }
//
//            })
        
     //   sideViewImage.kf.self.base
      //  sideViewImage.kf.setImageWithRetry(with: url)
        sideViewImage.kf.indicatorType = .activity
    
           // sideViewImage.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
    
        
       // self.sideViewImage.kf.
        
        self.sideViewUsername.text = displayName
        ImageService.getImage(withURL: user.photoURL!) { image in
                 self.sideViewImage.image = image
            self.imageSetup()
             }
    }
    
    
    
    
    func imageSetup(){
        sideViewImage.layer.borderWidth = 0.10
        sideViewImage.layer.cornerRadius = sideViewImage.frame.height / 2
        sideViewImage.layer.borderColor = UIColor.systemGray2.cgColor    }
    
    static func configureCell(user: User) {
        
    }
    
}

extension KingfisherWrapper where Base: UIImageView {
 @discardableResult
 func setImageWithRetry(
         with resource: URL?,
         retry: Int = 3,
         retryDelay: TimeInterval = 3.0,
         placeholder: Placeholder? = nil,
         options: KingfisherOptionsInfo? = nil,
         progressBlock: DownloadProgressBlock? = nil,
         completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {

     let downloadTask = setImage(with: resource,
                                 placeholder: placeholder,
                                 options: options, progressBlock: progressBlock) { result in
         switch result {
         case .success:
             completionHandler?(result)
         case .failure(let error):
             if retry > 0,
                 case .responseError(let reason) = error,
                 case .invalidHTTPStatusCode = reason {
                 DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) {
                     self.setImageWithRetry(
                         with: resource,
                         retry: retry - 1,
                         retryDelay: retryDelay,
                         placeholder: placeholder,
                         options: options,
                         progressBlock: progressBlock,
                         completionHandler: completionHandler)
                 }
             } else {
                 completionHandler?(result)
             }
         }
     }
     return downloadTask

}

}


class ImageService {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            var downloadedImage:UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
            
        }
        
        dataTask.resume()
    }
    
    static func getImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
}
