//
//  TabBarVC.swift
//  CustomerApp
//
//  Created by Apple on 22/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController , UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
      // self.navigationController?.isNavigationBarHidden = true
        addNavBarImage()
        
        self.tabBar.barTintColor =  UIColor.white
        
        let image = UIImage(named: "nav-icon")?.withRenderingMode(.alwaysOriginal)
        let button1 = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.ShowMenuDrawer)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.leftBarButtonItem  = button1
        changebarcolor()
        self.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        
        checkNetworkReachability()
        selectedIndex = 0
        
    }
    // called whenever a tab button is tapped
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController is ServicesViewController {
            print("service tab")
            
            if viewController.children.count > 0{
                let viewControllers:[UIViewController] = viewController.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
        }
    }

    func changebarcolor()  {
        
        navigationController?.navigationBar.barTintColor = UIColor.blue
        navigationController?.navigationBar.tintColor = UIColor.white

    }
    func addNavBarImage() {
        
        let navController = navigationController!
        
        let image = UIImage(named: "logo_in_1") //Your logo url here
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: 80, height: 40)
        imageView.contentMode = .center
        navigationItem.titleView = imageView
    }
    func checkNetworkReachability() {
        
        NetworkManager.isReachable { networkManagerInstance in
            print("Network is available")
        }
        
        NetworkManager.isUnreachable { networkManagerInstance in
            print("Network is Unavailable")
            let ac = UIAlertController(title: "No Internet.", message: "you are offline. Please  connect to the internet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
        
    }

    @objc func ShowMenuDrawer()
    {
        slideMenuController()?.toggleLeft()
    }
}

extension HomeViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
