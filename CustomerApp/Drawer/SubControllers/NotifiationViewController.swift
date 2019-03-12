//
//  NotifiationViewController.swift
//  CustomerApp
//
//  Created by Apple on 31/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit

class NotifiationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notification"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
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
