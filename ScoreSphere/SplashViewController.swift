//
//  SplashViewController.swift
//  ScoreSphere
//
//  Created by Macos on 24/05/2025.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    private var animationView: LottieAnimationView?

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white

            animationView = .init(name: "splash")
            animationView?.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
            animationView?.contentMode = .scaleAspectFit
            animationView?.loopMode = .playOnce
            animationView?.animationSpeed = 1.0

            if let animationView = animationView {
                view.addSubview(animationView)
            }

            
            animationView?.play { [weak self] finished in
                if finished {
                    self?.navigateToMainApp()
                }
            }
        }

        private func navigateToMainApp() {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBar = storyboard.instantiateViewController(withIdentifier: "OnBoarding") as? OnBoarding {
                tabBar.modalPresentationStyle = .fullScreen
                self.present(tabBar, animated: true, completion: nil)
            }
        }
    
}
