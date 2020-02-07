//
//  WalkthroughViewController.swift
//  AnywhereFitness
//
//  Created by Jesse Ruiz on 11/22/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//
// swiftlint:disable all
import UIKit

class WalkthroughViewController: UIViewController, WalkthroughPageViewControllerDelegate {

    // MARK: - Outlets

    @IBOutlet var newPageControl: UIPageControl!
    
    @IBOutlet var newNextButton: UIButton! {
        didSet {
            newNextButton.layer.cornerRadius = 25
            newNextButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var newSkipButton: UIButton!
    
    var walkthroughPageViewController: WalkthroughPageViewController?
    
    // MARK: - Actions
    @IBAction func newSkipButtonTapped(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newNextButtonTapped(sender: UIButton) {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...2:
                walkthroughPageViewController?.forwardPage()
            case 3:
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
        updateUI()
    }
    
    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...2:
                newNextButton.setTitle("NEXT", for: .normal)
                newSkipButton.isHidden = false
            case 3:
                newNextButton.setTitle("GET STARTED", for: .normal)
                newSkipButton.isHidden = true
            default:
                break
            }
            
            newPageControl.currentPage = index
        }
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }

}
