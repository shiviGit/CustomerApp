//
//  ImageHeaderCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/3/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

class ImageHeaderView : UIView
{
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var backgroundImage : UIImageView!
    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        self.profileImage.layoutIfNeeded()
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = UIColor.white.cgColor
//      self.profileImage.setRandomDownloadImage(80, height: 80)
//      self.backgroundImage.setRandomDownloadImage(Int(self.bounds.size.width), height: 160)
//        let appdele = UIApplication.shared.delegate as! AppDelegate
//        if appdele.userName["Photo"] != nil
//        {
//            if let decodedData = Data(base64Encoded: appdele.userName["Photo"] as! String,           options: .ignoreUnknownCharacters) {
//                let image = UIImage(data: decodedData)
//                self.profileImage.image = image
//            }
//        }
       self.profileImage.image = (#imageLiteral(resourceName: "userprofile"))
//        self.backgroundImage.image = (#imageLiteral(resourceName: "5"))
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if let person = appDelegate.userName["StudentName"] as? String
//        {
//            lbl.text = person
//        }
//        else
//        {
            lbl.text = UserDefaults.standard.string(forKey: "UserName")
//        }
    }
    
    
    
}
