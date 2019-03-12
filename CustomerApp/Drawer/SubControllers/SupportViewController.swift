//
//  SupportViewController.swift
//  CustomerApp
//
//  Created by Apple on 31/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit
import Alamofire

class SupportViewController: UIViewController, UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate , UITextViewDelegate{
    var myActivityIndicator  = UIActivityIndicatorView()
    @IBOutlet weak var tfComplaint: UITextField!
    @IBOutlet var tblList: UITableView!
    var categoryList : [String]  = ([] as NSMutableArray) as! [String]
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var commentview: UITextView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.title = "Support"
        setLoader()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tfComplaint.text = ""
        commentview.text = ""
        commentview.layer.borderWidth = 1
        commentview.layer.borderColor = UIColor .lightGray.cgColor
        commentview.backgroundColor = .clear

        commentview.text = "Please Enter your comments here....."
        commentview.textColor = UIColor.lightGray

        tblList.layer.borderWidth = 1
        tblList.layer.borderColor = UIColor .lightGray.cgColor
        

        GETCategory()
        
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

    @IBAction func clicked(_ sender: Any) {
        
        if (tfComplaint.text?.isEmpty)! {
            tfComplaint.becomeFirstResponder()
            return
        }
        
        if (commentview.text?.isEmpty)! {
            commentview.becomeFirstResponder()
            return
        }
        

        saveComp()
    }
    
    func saveComp()  {
        NetworkManager.isUnreachable { networkManagerInstance in
            print("Network is Unavailable")
            let ac = UIAlertController(title: "No Internet.", message: "you are offline. Please  connect to the internet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
            
            return
        }
        
        NetworkManager.isReachable { networkManagerInstance in
            print("Network is available")
            
            let  strdate = self.getTodayString()
            
            let parameters = [
                
                "mobile":         UserDefaults.standard.string(forKey: "UserID") as Any,
                "complaint_Type": self.tfComplaint.text as Any,
                "descri":         self.commentview.text as Any,
                "dateTime":       strdate
                ] as Dictionary<String, AnyObject>
            
            print(parameters)
            
            let url : String = String(format: "%@/Complaint/Insert", AppDelegate.SharedInstance.URLAddress)

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
                        let ac = UIAlertController(title: "Server not Found", message: "Server Not Found", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                        print(error)
                        
                    case .success(let value):
                        
                        print(value)
                        // let mydict = value as! Dictionary<String,Any>
                        let ac = UIAlertController(title: "", message: "Saved Successfully.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
                
                .responseString { response in
                    
                    print(response)
                    
            }
        }
    }    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.categoryList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tblList.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        // set the text from the data model
        
            cell.textLabel?.text = self.categoryList[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
            tfComplaint.text = self.categoryList[indexPath.row]
        
        tblList.isHidden=true
    }
    
    
    //TextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            tblList.frame = CGRect(x: tfComplaint.frame.origin.x, y: tfComplaint.frame.origin.y + tfComplaint.frame.size.height, width: tfComplaint.frame.size.width, height: 200)
            if(categoryList.count>0){
            }
            else
            {
                GETCategory()
            }
            
        
        tblList.tag = textField.tag
        tblList.reloadData()
        tblList.isHidden=false
        self.view.addSubview(tblList)
        self.view.endEditing(true)
        return false
    }
    
    
    func GETCategory(){
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
            
            let url : String = String(format: "%@/Customer/GetComplaintDescription", AppDelegate.SharedInstance.URLAddress)
            
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
                
                .responseJSON{response in
                    self.HideLoader()
                    
                    switch response.result
                    {
                        
                    case .failure(let error):
                        if let data = response.data {
                            print("Print ServerError: " + String(data: data, encoding: String.Encoding.utf8)!)
                        }
                        let ac = UIAlertController(title: "Server not Found", message: error as? String, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                        print(error)
                        
                        if(self.categoryList.count==0)
                        {
                            self.tblList.isHidden=true
                            
                        }
                        
                        
                    case .success(let value):
                        
                        print(value)
                        let mydict = value as! Dictionary<String,Any>
                        
                        let myarray = mydict["descriptionList"] as! [Dictionary<String,Any>]
                        self.categoryList.removeAll()
                        for obj in myarray
                        {
                            self.categoryList .append(obj["desc"] as! String)
                        }
                        self.categoryList = self.categoryList.removingDuplicates()
                        
                        print(mydict)
                        self.tblList.reloadData()
                        
                        if(self.categoryList.count==0)
                        {
                            self.tblList.isHidden=true
                            
                        }
                        
                        
                    }
                }
                
                .responseString{response in
                    print(response)
            }
            
            
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        tblList.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please Enter your comments here....."
            textView.textColor = UIColor.lightGray
        }
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        tblList.isHidden = true
        
    }


}

//extension Array where Element: Hashable {
//
//    func removingDuplicates() -> [Element] {
//        var addedDict = [Element: Bool]()
//
//        return filter {
//            addedDict.updateValue(true, forKey: $0) == nil
//        }
//    }
//
//    mutating func removeDuplicates() {
//        self = self.removingDuplicates()
//    }
//}
//
