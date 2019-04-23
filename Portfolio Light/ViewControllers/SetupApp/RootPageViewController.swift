//
//  RootPageViewController.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 13/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageControl = UIPageControl()
    
    lazy var viewControllerList:[UIViewController] = {
        
        let sb = UIStoryboard(name: "SetupApp", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: "initialVC")
        let vc2 = sb.instantiateViewController(withIdentifier: "secondVC")
        let vc3 = sb.instantiateViewController(withIdentifier: "thirdVC")
        return [vc1, vc2, vc3]
    }()
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = viewControllerList.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = .black
        self.pageControl.currentPageIndicatorTintColor = .myPurple
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = viewControllerList.index(of: pageContentViewController)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = viewControllerList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: false)
        }
        configurePageControl()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewControllerList.count > previousIndex else { return nil }
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else { return nil }
        guard viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
