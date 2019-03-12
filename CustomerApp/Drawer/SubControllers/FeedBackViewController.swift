//
//  FeedBackViewController.swift
//  CustomerApp
//
//  Created by Apple on 31/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit
import Alamofire

class FeedBackViewController: UIViewController , UITextViewDelegate{
    
    @IBOutlet weak var btnsubmit: UIButton!
    @IBOutlet weak var starRateView: StarRateView!
    var strRate = "0"
    var myActivityIndicator  = UIActivityIndicatorView()
    var today : String!
    
    @IBOutlet weak var commentView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feedback"
        setLoader()
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
   
    @IBAction func Submit(_ sender: Any) {
        
        sendFeedBack()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRatingView()
        commentView.text=""
        self.setNavigationBarItem()
        commentView.layer.borderWidth = 1
        commentView.layer.borderColor = UIColor .lightGray.cgColor
        commentView.backgroundColor = .clear
        commentView.becomeFirstResponder()
        commentView.text = "Please Enter your comments here....."
        commentView.textColor = UIColor.lightGray
        btnsubmit.frame.size.height = 40
        
    }

    
    func setupRatingView() {
        starRateView.delegate = self 
    starRateView.ratingValue = -1
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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

    func sendFeedBack()  {
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
            "mobile":UserDefaults.standard.string(forKey: "UserID"),
            "rating":self.strRate as String,
            "comment":self.commentView.text as String,
            "dateTime":self.today
            ] as Dictionary<String, AnyObject>
        
        print(parameters)
        
        let url : String = String(format: "%@/Post/Feedback", AppDelegate.SharedInstance.URLAddress)//server
        
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
                   // let mydict = value as! Dictionary<String,Any>
                    let ac = UIAlertController(title: "", message: "FeedBack Sent.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
            .responseString { response in
                
                print(response)
        }
    }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please Enter your comments here....."
            textView.textColor = UIColor.lightGray
        }
    }
    
}

extension FeedBackViewController: RatingViewDelegate {
        func updateRatingFormatValue(_ value: Int) {
            print("Rating : = ", value)
            self.strRate = String(format: "%d", value)
        }
}
