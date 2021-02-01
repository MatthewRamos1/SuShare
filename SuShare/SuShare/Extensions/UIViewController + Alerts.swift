//
//  UIViewController + Alerts.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showUploadAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func confirmingShowAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "no", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "yes", style: .destructive, handler: nil)
        
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private static func resetWindow(with rootViewController: UIViewController) {
      guard let scene = UIApplication.shared.connectedScenes.first,
        let sceneDelegate = scene.delegate as? SceneDelegate,
        let window = sceneDelegate.window else {
          fatalError("could not reset window rootViewController")
      }
      window.rootViewController = rootViewController
    }
    
    public static func showViewController(storyBoardName: String, viewControllerId: String) {
      let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
      let newVC = storyboard.instantiateViewController(identifier: viewControllerId)
      resetWindow(with: newVC)
    }
    
    public static func showVC(viewcontroller: UIViewController) {
      resetWindow(with: viewcontroller)
    }
}
