//
//  VerificationViewController.swift
//  CustomerApp
//
//  Created by Apple on 22/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit
import Alamofire
class VerificationViewController: UIViewController , UITextFieldDelegate {
var myotp = "0000"
    @IBOutlet weak var TFOTP: UITextField!
    var myActivityIndicator  = UIActivityIndicatorView()
    var today : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLoader()
        sendOTP()
        //self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
        checkNetworkReachability()

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

    @IBAction func poptoroot(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func sendOTP()  {
        
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
        let parameters = [
            "number":AppDelegate.SharedInstance.MobileNoOfUSer,
            ] as Dictionary<String, AnyObject>
        
        print(parameters)
        
            let url : String = String(format: "%@/SendOtp/Tonumber", AppDelegate.SharedInstance.URLAddress)//server new url
//            let url : String = String(format: "%@/alien/alien/sendOtp", AppDelegate.SharedInstance.URLAddress)//server old url
        
        print(url)
            self.ShowLoader()
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            
            .responseJSON { response in
                self.HideLoader()
                
                switch response.result
                {
                    
                case .failure(let error):
                    if let data = response.data {
                        print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                    }
                    let ac = UIAlertController(title: "Server not Found", message: error as? String, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                    print(error)
                    
                case .success(let value):
                    
                    print(value)
                    let mydict = value as! Dictionary<String,Any>
                    self.myotp = mydict["otp"] as! String
                    print("my otp is @ ",self.myotp)
                    let ac = UIAlertController(title: "", message: String(format: "OTP Sent On Mobile NO. %@", AppDelegate.SharedInstance.MobileNoOfUSer), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
        }
            .responseString { response in

                print(response)
        }
    }
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


    @IBAction func VerifyME(_ sender: Any) {
        if (TFOTP.text!.isEmpty)
        {
            let ac = UIAlertController(title: "", message: "Please Enter OTP.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)

            return
        }
        if TFOTP.text == myotp {
            UserDefaults.standard.set(AppDelegate.SharedInstance.MobileNoOfUSer, forKey: "UserID") //Bool
            UserDefaults.standard.set(AppDelegate.SharedInstance.NameOfUSer, forKey: "UserName") //Bool
            sendDetailToServer()
            //GoToHome()
        }
        else
        {
            let ac = UIAlertController(title: "Invalid OTP", message: "Please Enter Valid OTP.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func ResendOTP(_ sender: Any) {
        sendOTP()
    }
    
    func GoToHome()  {
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
    
    
    func sendDetailToServer()  {
        today = getTodayString()
        let parameters = [
            "mobile":AppDelegate.SharedInstance.MobileNoOfUSer,
            "creationDate":today
            ] as Dictionary<String, AnyObject>
        
        print(parameters)
        
        let url : String = String(format: "%@/Txn/Create/FirstTimeAccount", AppDelegate.SharedInstance.URLAddress)//server
        // let url : String = "http://192.168.6.146:8779/DemoRest/alien/alien/sendOtp"//local
        
        
        print(url)
        ShowLoader()
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            
            .responseJSON { response in
                self.HideLoader()
                
                switch response.result
                {
                    
                case .failure(let error):
                    if let data = response.data {
                        print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                    }
                    let ac = UIAlertController(title: "Server not Found", message: error as? String, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                    print(error)
                    
                case .success(let value):
                    
                    print(value)
                    let mydict = value as! Dictionary<String,Any>
                    
                    let sts = mydict["status"] as! String
                    if (sts == "4")
                    {
                        
                        let message = mydict["description"] as! String
                        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        self.present(alert, animated: true)
                        
                        // duration in seconds
                        let duration: Double = 1
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                            alert.dismiss(animated: true)
                        }

                    }
                    
                    
                    self.GoToHome()
                }
            }
            .responseString { response in
                
                print(response)
        }
    }
    
    
    //TextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Editing is about to begin")
        //        textField.layer.borderWidth = 1
        //        textField.layer.borderColor = UIColor .lightGray.cgColor
        return true
    }
    
    // Called when the editing is began
    private func textFieldDidBeginEditing(textField: UITextField) {
        textField.backgroundColor = UIColor.green
        print("Editing is began")
    }
    
    // Called when the editing is about to end
    private func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("Editing is about to end")
        return true
    }
    
    // Called when the editing ended
    private func textFieldDidEndEditing(textField: UITextField) {
        textField.backgroundColor = UIColor.white
        print("Editing ended")
    }
    
    // Called whenever the user types a new character in the text field or deletes an existing character. For example, you can use this method to disallow the use of a certain character, in this case “$” character
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag==10{
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            
            if((textField.text?.length)!==4)
            {
              //  self.view.endEditing(true)
            }

            if((textField.text?.length)!>3)
            {
                guard let text = textField.text else { return true }
                let count = text.count + string.count - range.length
                return count <= 4
            }
            return string.rangeOfCharacter(from: invalidCharacters) == nil
        }
        else
        {
            return true
        }
    }
    
    // Called when the clearButton is pressed
    private func textFieldShouldClear(textField: UITextField) -> Bool {
        print("Clear button pressed")
        return true
    }
    
    // Called when the keyboard return key is pressed
    private func textFieldShouldReturn(textField: UITextField) -> Bool{
        return true
    }
    

}
