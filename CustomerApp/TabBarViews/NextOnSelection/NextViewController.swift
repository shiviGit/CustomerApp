//
//  NextViewController.swift
//  CustomerApp
//
//  Created by Apple on 23/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit
import Alamofire

class NextViewController: UIViewController {

    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    public var strValue = ""
    var today : String!
    var myActivityIndicator  = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        imgView.image = UIImage(named: String(format: "%@.png", strValue))

        btnBook.setTitle(String(format: "Book Now For %@", strValue), for: .normal)
        //self.navigationController?.setToolbarHidden(false, animated: true)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        checkNetworkReachability()
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
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        return today_string
        
    }
    func setLoader()  {
        myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
    }
    
    func ShowLoader()  {
        
        view.addSubview(myActivityIndicator)
        myActivityIndicator.startAnimating()
        view.isUserInteractionEnabled=false
    }
    
    func HideLoader()  {
        self.myActivityIndicator.stopAnimating()
        self.myActivityIndicator.removeFromSuperview()
        view.isUserInteractionEnabled=true
    }

    @IBAction func BookClicked(_ sender: Any) {
        
        NetworkManager.isUnreachable { networkManagerInstance in
            print("Network is Unavailable")
            let ac = UIAlertController(title: "No Internet.", message: "you are offline. Please  connect to the internet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
            return
        }
        NetworkManager.isReachable { networkManagerInstance in
            print("Network is available")

            self.today = self.getTodayString()
        
        let param = [
            "creationDate":self.today,
            "leadSource":"iOS",
            "firstName":UserDefaults.standard.string(forKey: "UserName") ,
            "lastName":"",
            "mobile1":UserDefaults.standard.string(forKey: "UserID"),
            "eMail1":"",
            "carMake":"",
            "carModel":"",
            "address":"",
            "locality":"",
            "city":"",
            "leadIntent":self.strValue
            ] as Dictionary<String, AnyObject>
        
        print(param)
        
        let url : String = String(format: "%@/Lead/Insert", AppDelegate.SharedInstance.URLAddress)//server
        
        print(url)
            self.ShowLoader()
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            
            .responseJSON { response in
                self.HideLoader()
                var str = ""
                switch response.result
                {
                    
                case .failure(let error):
                    if let data = response.data {
                        print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                        
                        print(error)
                    }
                    
                    str = "Sorry Request failed, please try after some time."
                    
                case .success(let value):
                    
                    print(value)
                    // let mydict = value as! Dictionary<String,Any>
                    str = "Request Raised."
                    
                }
                
                NotificationCenter.default.post(name: Notification.Name("Hello"), object: str)

            }
            
            .responseString{ response in
                    print(response)
                    
//                    let str = response as Any
//                    print(str as Any)
//                    NotificationCenter.default.post(name: Notification.Name("Hello"), object: str)

                    
        }
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()

       // self.navigationController?.popViewController(animated: true)
    }
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
