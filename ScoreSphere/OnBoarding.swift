//
//  OnBoarding.swift
//  ScoreSphere
//
//  Created by Macos on 24/05/2025.
//

import UIKit

class OnBoarding: UIPageViewController ,UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = arr.firstIndex(of:viewController) else { return nil }
        let prev = currentIndex - 1
        guard prev >= 0 else {
            return nil
        }
        
        return arr[prev]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = arr.firstIndex(of:viewController) else { return nil }
        let afterIndex = currentIndex + 1
        guard afterIndex < arr.count else {
            return nil
        }
        
        return arr[afterIndex]
    }
    
    var arr = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
           self.dataSource = self
        let p1 = (self.storyboard?.instantiateViewController(identifier: "p1"))
        let p2 = self.storyboard?.instantiateViewController(identifier: "p2")
        let p3 = self.storyboard?.instantiateViewController(identifier: "p3")
        arr.append(p1!)
        arr.append(p2!)
        arr.append(p3!)
        if let firstVC = arr.first{(setViewControllers([firstVC], direction: .forward, animated: true, completion: nil))}
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
