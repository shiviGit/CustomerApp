//
//  LOGViewController.swift
//  CustomerApp
//
//  Created by Apple on 27/02/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit

class LOGViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func GoToHome(_ sender: Any) {
        
                    let storyboard = UIStoryboard( name: "Main", bundle: nil)
                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    let nvc: UINavigationController = UINavigationController(rootViewController: loginViewController)
                    UIApplication.shared.keyWindow?.rootViewController = nvc
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
