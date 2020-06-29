//
//  WalkthroughViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/28/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {

    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var skipButton: UIButton!
      
    var walkthroughPageViewController: WalkthroughPageViewController?
    
    @IBAction func skipButtonTapped(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
        navigateToMainView()
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                walkthroughPageViewController?.forwardPage()
                
            case 2:
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            }
        }
        updateUI()
        navigateToMainView()
    }
    
    private func navigateToMainView() {
        UIViewController.showVC(viewcontroller: TabController())
    }
    
    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle("NEXT", for: .normal)
                skipButton.isHidden = false
            
            case 2:
                nextButton.setTitle("GET STARTED", for: .normal)
                skipButton.isHidden = true
                
            default: break
            }
            pageControl.currentPage = index
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
}

extension WalkthroughViewController: WalkthroughPageViewControllerDelegate {
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}
