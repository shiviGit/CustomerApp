//
//  HomeViewController.swift
//  CustomerApp
//
//  Created by Apple on 22/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var MyImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        let myImagesArray=[UIImage(named:"car1.png"),UIImage(named:"car2.png"),UIImage(named:"car3.png")]
        MyImgView.animationImages=myImagesArray as? [UIImage]
        MyImgView.animationDuration=TimeInterval(2*myImagesArray.count)
        //to make it loop infinitely
        MyImgView.animationRepeatCount=0
        MyImgView.startAnimating()
        
    }
    @IBAction func ShowMenuDrawer(sender: UIButton)
    {
        slideMenuController()?.toggleLeft()
    }
    


}
