//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum LeftMenu: Int {
    case Profile = 0
    case Car
   // case Offers
   // case ReferAndEarn
    case FeedBAck
   // case Notification
   // case ChangePw
    case Support
    case Home
    case Logout
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["My Profile","Car Details", "Feedback"  , "Raise Complaint","Home","Logout" ]
 //   var menus = ["My Profile", "Offers", "Refer and Earn ", "Feedback",  "Notification" , "Change Password" , "Support","Home","Logout" ]
    var imgMenus = [#imageLiteral(resourceName: "aboutus24"),#imageLiteral(resourceName: "Service"), #imageLiteral(resourceName: "contact321"), #imageLiteral(resourceName: "call24"), #imageLiteral(resourceName: "home32"), #imageLiteral(resourceName: "placeholder24") ]
   
    var mainViewController: UIViewController!
    var profileVC: UIViewController!
    var CarVC:UIViewController!
    var offersVC: UIViewController!
    var ReferVC: UIViewController!
    var FeedVC: UIViewController!
    var NotificationVC: UIViewController!
    var ChangePWVC: UIViewController!
    var SupportVC: UIViewController!
    var LOGVC: UIViewController!

    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor.clear
        self.tableView.backgroundColor = UIColor.white
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       
        let Profile = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.profileVC = UINavigationController(rootViewController: Profile)
        
        let Car = storyboard.instantiateViewController(withIdentifier: "CarViewController") as! CarViewController
        self.CarVC = UINavigationController(rootViewController: Car)
        //self.profileVC = Profile

        let Offers = storyboard.instantiateViewController(withIdentifier: "OfferViewController") as! OfferViewController
        self.offersVC = UINavigationController(rootViewController: Offers)

        let Refer = storyboard.instantiateViewController(withIdentifier: "Refer_EarnViewController") as! Refer_EarnViewController
        self.ReferVC = UINavigationController(rootViewController: Refer)

        let feed = storyboard.instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
        self.FeedVC = UINavigationController(rootViewController: feed)
        
        let noti = storyboard.instantiateViewController(withIdentifier: "NotifiationViewController") as! NotifiationViewController
        self.NotificationVC = UINavigationController(rootViewController: noti)

        let ChangePW = storyboard.instantiateViewController(withIdentifier: "ChangePwViewController") as! ChangePwViewController
        self.ChangePWVC = UINavigationController(rootViewController: ChangePW)
       
        let support = storyboard.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
        self.SupportVC = UINavigationController(rootViewController: support)
       
        let LOG = storyboard.instantiateViewController(withIdentifier: "LOGViewController") as! LOGViewController
        self.LOGVC = UINavigationController(rootViewController: LOG)

        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .Profile:
            self.slideMenuController()?.changeMainViewController(self.profileVC, close: true)
        case .Car:
            self.slideMenuController()?.changeMainViewController(self.CarVC, close: true)
//        case .Offers:
//            self.slideMenuController()?.changeMainViewController(self.offersVC, close: true)
//        case .ReferAndEarn:
//            self.slideMenuController()?.changeMainViewController(self.ReferVC, close: true)
        case .FeedBAck:
            self.slideMenuController()?.changeMainViewController(self.FeedVC, close: true)
//        case .Notification:
//            self.slideMenuController()?.changeMainViewController(self.NotificationVC, close: true)
//        case .ChangePw:
//            self.slideMenuController()?.changeMainViewController(self.ChangePWVC, close: true)
        case .Support:
            self.slideMenuController()?.changeMainViewController(self.SupportVC, close: true)
        case.Home :
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .Logout:
            
 ///////////////////////////////////////********************************////////////////////////////////////////
            // logout the page and go to the root view
            
//            UserDefaults.standard.removeObject(forKey: "UserID")
//            UserDefaults.standard.removeObject(forKey: "UserName")
//            let storyboard = UIStoryboard( name: "Main", bundle: nil)
//            let loginViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//            let nvc: UINavigationController = UINavigationController(rootViewController: loginViewController)
//            UIApplication.shared.keyWindow?.rootViewController = nvc
            
 ////////////////////////////////////////********************************////////////////////////////////////////
            
                        UserDefaults.standard.removeObject(forKey: "UserID")
                        UserDefaults.standard.removeObject(forKey: "UserName")

            
            //here user just exit from the app and can directly go to home next time of app launching
            self.slideMenuController()?.changeMainViewController(self.LOGVC, close: true)
            
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu
            {
//            case .Profile, .Offers, .ReferAndEarn, .FeedBAck, .Notification, .ChangePw, .Support, .Home,.Logout:
            case .Profile,.Car, .FeedBAck, .Support, .Home,.Logout:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
        //return menus.count
}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
//            case .Profile, .Offers, .ReferAndEarn, .FeedBAck, .Notification, .ChangePw, .Support, .Home,.Logout:
            case .Profile, .Car,.FeedBAck, .Support, .Home,.Logout:
                let cell:BaseTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "BaseTableViewCell") as! BaseTableViewCell
               // let cell = BaseTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "BaseTableViewCell")
                cell.setData(menus[indexPath.row])
                cell.setImg(imgMenus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
