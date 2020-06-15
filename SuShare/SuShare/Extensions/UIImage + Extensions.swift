//
//  UIImage + Extensions.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    static func resizeImage(originalImage: UIImage, rect: CGRect) -> UIImage {
      let rect = AVMakeRect(aspectRatio: originalImage.size, insideRect: rect)
      let size = CGSize(width: rect.width, height: rect.height)
      let renderer = UIGraphicsImageRenderer(size: size)
      return renderer.image { (context) in
        originalImage.draw(in: CGRect(origin: .zero, size: size))
      }
    }
}

