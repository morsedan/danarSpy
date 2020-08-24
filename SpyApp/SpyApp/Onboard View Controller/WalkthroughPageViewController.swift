//
//  WalkthroughPageViewController.swift
//  AnywhereFitness
//
//  Created by Jesse Ruiz on 11/22/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//
// swiftlint:disable all
import UIKit

protocol WalkthroughPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    // MARK: - Properties
    var pageHeadings = ["Welcome to Spy", "Pass 'n' Play", "Pass 'n' Play", "Local Play"]
    var pageImages = ["IconNoBG", "PassnPlay","PassnPlay", "LocalPlay"]
    var pageSubHeadings = ["The game where you must find the odd person out.", "Using one device, input the number of players and pass the phone around clockwise to see what role you are. One person will be assigned a unique role (Spy) from everyone else (Defenders). Go around one more time in the same order, making a statement about your role.", "You may not repeat the same statement. At the end, everyone votes on 1 person who they believe is the spy. Whoever has the most votes is eliminated! If the spy was voted off, the Defenders win. If not the game continues. The spy wins if they are 1 of the last 2 players alive.", "It’s the same rules as Pass ’n’ Play, except you can have use your own device to play! Everyone can download the app, and play all together as long as they are in the same room. Things get sneakier when you don’t have to share a device 😉."]
    
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - Page View Controller Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    // MARK: - Helper
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(identifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                currentIndex = contentViewController.index
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }

}
