//
//  ViewController.swift
//  CustomerApp
//
//  Created by Apple on 22/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit
import LocalAuthentication
class ViewController: UIViewController , UITextFieldDelegate , UICollectionViewDelegate {

    let Network : NetworkManager = NetworkManager.sharedInstance
    let bun : UIButton = UIButton()
    let OverlapeView = UIImageView()
    @IBOutlet weak var TFMobile: UITextField!
    @IBOutlet weak var TFName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OverlapeView.image = UIImage.init(named: "landing4")
        OverlapeView.frame.size = self.view.frame.size
        self.view.addSubview(OverlapeView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        //self.authenticateUser()
        
        self.checkNetworkReachability()
        self.navigationController?.isNavigationBarHidden=true
        if UserDefaults.standard.object(forKey: "UserID") != nil{
            let uservalueis =  UserDefaults.standard.string(forKey: "UserID")
            
            if ((uservalueis?.isEmpty)!)
            {
                OverlapeView.removeFromSuperview()
            }
            else
            {
                self.runSecretCode()
            }
        }
        else
        {
            OverlapeView.removeFromSuperview()
        }

    }
   
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        
                        self.runSecretCode()
                        
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        }
        else
        {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    
    @IBAction func GoToVerify(_ sender: Any) {
        checkNetworkReachability()
        if(TFName.text?.isEmpty)!
        {
//            TFName.layer.borderWidth = 1
//            TFName.layer.borderColor = UIColor .red.cgColor
            TFName.becomeFirstResponder()
            return
        }

 
        let UMNstr = TFMobile.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        //validating that values are not empty
        if(UMNstr?.isEmpty)!
        {
//            TFMobile.layer.borderWidth = 1
//            TFMobile.layer.borderColor = UIColor .red.cgColor
            TFMobile.becomeFirstResponder()
            return
        }
        if((UMNstr?.count)!<=9 || (UMNstr?.count)!>10)
        {
            print("API Count is not 10")
            let ac = UIAlertController(title: "Invalid Mobile No.", message: "Please check Your Mobile No.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        else{
            if(isValidMobile(testStr: TFMobile.text!)){
                print("valid")
            }
            else
            {
                let ac = UIAlertController(title: "Invalid Mobile.", message: "Please enter a valid Mobile no.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
                
                return
            }
            
            
        }
        
        AppDelegate.SharedInstance.MobileNoOfUSer = TFMobile.text!
        AppDelegate.SharedInstance.NameOfUSer = TFName.text!

        let next = self.storyboard?.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    func runSecretCode()
    {
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
        
        OverlapeView.removeFromSuperview()
        
        UIApplication.shared.keyWindow?.rootViewController = slideMenuController

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
            if((textField.text?.length)!>9)
            {
                guard let text = textField.text else { return true }
                let count = text.count + string.count - range.length
                return count <= 10
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
    
    func isValidMobile(testStr:String) -> Bool {
        
        let mobRegEx = "^[6-9]\\d{9}$"
        let mobTest = NSPredicate(format:"SELF MATCHES %@", mobRegEx)
        return mobTest.evaluate(with: testStr)
        
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
    
}

extension UIViewController{
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
}
