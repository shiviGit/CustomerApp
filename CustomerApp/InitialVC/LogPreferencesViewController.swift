//
//  LogPreferencesViewController.swift
//  CustomerApp
//
//  Created by Apple on 22/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit

class LogPreferencesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func PushAction(_ sender: Any) {
        
        
            print("Run")
            //        let tab = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            //        self.navigationController?.pushViewController(tab, animated: true)
            
            
            ///////NavigationDrawer/////
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
            let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
            
            let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
            
            UINavigationBar.appearance().tintColor = UIColor.blue
            
            leftViewController.mainViewController = nvc
            
            let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
            //  slideMenuController.automaticallyAdjustsScrollViewInsets = true
            slideMenuController.delegate = mainViewController as? SlideMenuControllerDelegate
            
            UIApplication.shared.keyWindow?.rootViewController = slideMenuController
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
