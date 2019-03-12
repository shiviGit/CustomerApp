//
//  ProfileViewController.swift
//  CustomerApp
//
//  Created by Apple on 31/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController ,UITextFieldDelegate{
    
    var myActivityIndicator  = UIActivityIndicatorView()

    @IBOutlet weak var TFFirstName: UITextField!
    @IBOutlet weak var TFLastNAme: UITextField!
    @IBOutlet weak var TFMobile: UITextField!
    @IBOutlet weak var TFEmail: UITextField!
    @IBOutlet weak var TFAddress: UITextField!
    @IBOutlet weak var TFLocality: UITextField!
    @IBOutlet weak var TFPinCode: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Personal Details"
        self.setNavigationBarItem()
       // TFFirstName.text = UserDefaults.standard.string(forKey: "UserName")
        TFMobile.text = UserDefaults.standard.string(forKey: "UserID")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //   self.setNavigationBarItem()
        self.setLoader()
        
        
        GetDetails()
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

    @IBAction func SubmitClicked(_ sender: Any) {
        
        if (TFFirstName.text?.isEmpty)! {
            TFFirstName.becomeFirstResponder()
            return
        }
        if (TFLastNAme.text?.isEmpty)! {
            TFLastNAme.becomeFirstResponder()
            return
        }
        if (TFMobile.text?.isEmpty)! {
            TFMobile.becomeFirstResponder()
            return
            
        }
        if (TFEmail.text?.isEmpty)! {
            TFEmail.becomeFirstResponder()
            return
            
        }else{
            if(isValidEmail(testStr: TFEmail.text!)){
                print("valid")
            }
            else
            {
                let ac = UIAlertController(title: "Invalid Email Address.", message: "Please enter a valid email address.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
            
        }
        
        
//        if (TFAddress.text?.isEmpty)! {
//            TFAddress.becomeFirstResponder()
//            return
//            
//        }
//        if (TFLocality.text?.isEmpty)! {
//            TFLocality.becomeFirstResponder()
//            return
//            
//        }
//        if (TFPinCode.text?.isEmpty)! {
//            TFPinCode.becomeFirstResponder()
//            return
//            
//        }
//        else
//        {
//            if((TFPinCode.text?.length)!<6){
//                
//                let ac = UIAlertController(title: "Invalid PIN.", message: "Please enter a valid PIN.", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .default))
//                self.present(ac, animated: true)
//
//            }
//            
//            
//        }
        saveProfile()
    }
    func saveProfile()  {
        
        NetworkManager.isUnreachable { networkManagerInstance in
            print("Network is Unavailable")
            let ac = UIAlertController(title: "No Internet.", message: "you are offline. Please  connect to the internet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
            
            return
        }
        NetworkManager.isReachable { networkManagerInstance in
            print("Network is available")

    
        let parameters = [
            "firstName":self.TFFirstName.text,
            
            "lastName":self.TFLastNAme.text,
            
            "email1":self.TFEmail.text,
            
            "address":self.TFAddress.text,
            
            "locality":self.TFLocality.text,
            
            "pincode":self.TFPinCode.text,
            
            "mobile1":self.TFMobile.text
            ] as Dictionary<String, AnyObject>
        
        print(parameters)
        
        let url : String = String(format: "%@/Txn/Update/TxnProfile", AppDelegate.SharedInstance.URLAddress)
        
        print(url)
            self.ShowLoader()
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            
            .responseJSON { response in
                self.HideLoader()
                
                switch response.result
                {
                    
                case .failure(let error):
                    if let data = response.data {
                        print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                    }
                    let ac = UIAlertController(title: "Server not Found", message: "Server Not Found", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                    print(error)
                    
                case .success(let value):
                    
                    print(value)
                   // let mydict = value as! Dictionary<String,Any>
                    let strname = String(format: "%@%@", self.TFFirstName.text!,self.TFLastNAme.text!)
                    UserDefaults.standard.set(strname, forKey: "UserName")

                    let ac = UIAlertController(title: "", message: "Saved Successfully.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
        }
            
            .responseString { response in
            
                print(response)
                
        }
        }
    }
   
    func GetDetails()
    {
        
        NetworkManager.isUnreachable { networkManagerInstance in
            print("Network is Unavailable")
            let ac = UIAlertController(title: "No Internet.", message: "you are offline. Please  connect to the internet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
            
            return
        }
        
        NetworkManager.isReachable { networkManagerInstance in
            print("Network is available")


            self.ShowLoader()
        
        let url = String(format: "%@/Profile/Fetch/mobile=\'%@\'", AppDelegate.SharedInstance.URLAddress,UserDefaults.standard.string(forKey: "UserID")!)
        
        print(url)
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        
        Alamofire.request(urlString!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            
            .responseJSON{response in
                print(response)
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
                    if(mydict.count>0){
                        
                        if let val = mydict["firstName"] {
                            let strname = String(format: "%@%@", val as! String,mydict["lastName"] as? String ?? "")
                            UserDefaults.standard.set(strname, forKey: "UserName")
                        }

                        self.TFFirstName.text = mydict["firstName"] as? String
                        self.TFLastNAme.text = mydict["lastName"] as? String
                      //self.TFMobile.text = mydict["firstName"] as? String
                        self.TFEmail.text = mydict["email1"] as? String
                        self.TFAddress.text = mydict["address"] as? String
                        self.TFLocality.text = mydict["locality"] as? String
                        self.TFPinCode.text = mydict["pincode"] as? String
                    }
                }
        }
        
    }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    

    
   
    
    // Called whenever the user types a new character in the text field or deletes an existing character. For example, you can use this method to disallow the use of a certain character, in this case “$” character
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag==10{
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            if((textField.text?.length)!>5)
            {
                guard let text = textField.text else { return true }
                let count = text.count + string.count - range.length
                return count <= 6
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
        
        print("return")

        return true
    }

    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // add if for some desired textfields
        
        print("move up")
        
        if textField.tag == 101 {
            self.view.frame = CGRect (x: 0, y: -100, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
        if textField.tag == 10 {
            self.view.frame = CGRect (x: 0, y: -100, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("move Down")
        if textField.tag == 101 {
            self.view.frame = CGRect (x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
        if textField.tag == 10 {
            self.view.frame = CGRect (x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }

        
    }
    

}
