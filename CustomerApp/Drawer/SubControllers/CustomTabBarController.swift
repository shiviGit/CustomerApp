//
//  CustomTabBarController.swift
//  CustomerApp
//
//  Created by Apple on 14/02/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import Foundation
import UIKit
class CustomTabBarController: UITabBarController {
    
    @IBOutlet weak var financialTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  I've added this line to viewDidLoad
        //  UIApplication.shared.statusBarFrame.size.height
        //  financialTabBar.frame = CGRect(x: 0, y:  financialTabBar.frame.size.height, width: financialTabBar.frame.size.width, height: financialTabBar.frame.size.height)
        
        self.setNavigationBarItem()

}
//    override func viewWillAppear(_ animated: Bool) {
//        
//     self.viewWillLayoutSubviews()    }
//    
//    
//    override func viewWillLayoutSubviews() {
//      
//        //super.viewWillLayoutSubviews()
//        var tabFrame:CGRect = self.tabBar.frame
//        tabFrame.origin.y = self.view.frame.origin.y + self.tabBar.frame.size.height + 20
//        self.tabBar.frame = tabFrame
//        
//    }

}
