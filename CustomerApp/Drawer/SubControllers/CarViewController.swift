//
//  CarViewController.swift
//  CustomerApp
//
//  Created by Apple on 18/02/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit
import Alamofire
class CarViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate {
    var myActivityIndicator  = UIActivityIndicatorView()
    @IBOutlet weak var tfcarmake: UITextField!
    @IBOutlet var tblList: UITableView!
    @IBOutlet weak var tffuletype: UITextField!
    
    @IBOutlet weak var tfcarmodel: UITextField!
    var Fuel  : [String]  = ["Maruti", "Suzuki", "TATA"]
    var brand : [String]  = ([] as NSMutableArray) as! [String]
    var model : [String]  = []
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.setNavigationBarItem()
self.title = "Car Details"
        setLoader()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
                            tblList.layer.borderWidth = 1
                            tblList.layer.borderColor = UIColor .lightGray.cgColor

        GetDetails()
        
       // GETBrands()
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

    @IBAction func RCUpload(_ sender: Any) {
   
        /////encoding////
        //Use image name from bundle to create NSData
        let image : UIImage = UIImage(named: "logo_in_1")!
        //Now use image to create into NSData format
        let imageData:NSData = image.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        print(strBase64)
        self.uploadbase64str(strBase64: strBase64 , strtype: "RC")
        
        /////decoding////
        let dataDecoded:NSData = NSData(base64Encoded: strBase64, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        print(decodedimage)
        //yourImageView.image = decodedimage

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

    func uploadbase64str(strBase64:String , strtype:String)  {
    
    NetworkManager.isUnreachable { networkManagerInstance in
    print("Network is Unavailable")
    let ac = UIAlertController(title: "No Internet.", message: "you are offline. Please  connect to the internet.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(ac, animated: true)
    
    return
    }
    NetworkManager.isReachable { networkManagerInstance in
    print("Network is available")
    
    let today = self.getTodayString()
    let parameters = [
    "mobile":AppDelegate.SharedInstance.MobileNoOfUSer,
    "numberPlate":"",
    "email":"",
    "imageType":strtype,
    "imageName":"",
    "imageString":strBase64,
        "createdBy":"ios",
        "createdDate":today,
        "modifiedBy":"ios",
        "modifiedDate":today,
        "isActive":"y",
    ] as Dictionary<String, AnyObject>
    
    print(parameters)
    
    let url : String = String(format: "%@/Upload/txnImage", AppDelegate.SharedInstance.URLAddress)//server new url
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
    print(mydict)
//    let ac = UIAlertController(title: "", message: String(format: "OTP Sent On Mobile NO. %@", AppDelegate.SharedInstance.MobileNoOfUSer), preferredStyle: .alert)
//    ac.addAction(UIAlertAction(title: "OK", style: .default))
//    self.present(ac, animated: true)
    }
    }
    .responseString { response in
    
    print(response)
    }
    }
    }
    
    @IBAction func InsurUpload(_ sender: Any) {
       
       // self.uploadImg(image: #imageLiteral(resourceName: "6"))
        
 }
    @IBAction func clicked(_ sender: Any) {
            
            if (tfcarmake.text?.isEmpty)! {
                tfcarmake.becomeFirstResponder()
                return
            }
            if (tfcarmodel.text?.isEmpty)! {
                tfcarmodel.becomeFirstResponder()
                return
            }
            if (tffuletype.text?.isEmpty)! {
                tffuletype.becomeFirstResponder()
                return
            }
        
            saveCarDetail()
        }
   
    
        func saveCarDetail()  {
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
                "carMake":self.tfcarmake.text,
                
                "carModel":self.tfcarmodel.text,
                
                "fuelType":self.tffuletype.text,
                
                "mobile": UserDefaults.standard.string(forKey: "UserID")
                ] as Dictionary<String, AnyObject>
            
            print(parameters)
            
            let url : String = String(format: "%@/Txn/UpdateCar/Details", AppDelegate.SharedInstance.URLAddress)
            
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
        
        if tblList.tag == 10 {
            return self.brand.count
            
        }
        if tblList.tag == 11 {
            return self.model.count
            
        }
        if tblList.tag == 12 {
            return self.Fuel.count
            
        }
        else
        {return 0}

    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tblList.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        // set the text from the data model
        if tableView.tag == 10 {
            
            cell.textLabel?.text = self.brand[indexPath.row]
        }
        if tableView.tag == 11 {
            
            cell.textLabel?.text = self.model[indexPath.row]
        }
        if tableView.tag == 12 {
            
            cell.textLabel?.text = self.Fuel[indexPath.row]
        }

        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")

        if tableView.tag == 10 {

            tfcarmake.text = self.brand[indexPath.row]
            tfcarmodel.text = ""
            tffuletype.text = ""
        }
        if tableView.tag == 11 {

            tfcarmodel.text = self.model[indexPath.row]
            tffuletype.text = ""

        }
        if tableView.tag == 12 {

            tffuletype.text = self.Fuel[indexPath.row]
        }

        tblList.isHidden=true
    }

    
    //TextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField.tag == 10){
            tblList.frame = CGRect(x: tfcarmake.frame.origin.x, y: tfcarmake.frame.origin.y + tfcarmake.frame.size.height, width: tfcarmake.frame.size.width, height: 200)
            if(brand.count>0){
            }
            else
            {
                GETBrands()
            }
            tblList.tag = textField.tag
            tblList.reloadData()
            tblList.isHidden=false
            if brand.count == 0 {
                tblList.isHidden=false
            }
            self.view.addSubview(tblList)

        }
        if(textField.tag == 11){
            
            if((tfcarmake.text?.isEmpty)!)
            { tfcarmake.becomeFirstResponder()
                return false}
            tblList.frame = CGRect(x: tfcarmodel.frame.origin.x, y: tfcarmodel.frame.origin.y + tfcarmodel.frame.size.height, width: tfcarmodel.frame.size.width, height: 200)
            
            model.removeAll()
            self.GetModel(strBrand: tfcarmake.text!)
            tblList.tag = textField.tag
            tblList.reloadData()
            tblList.isHidden=false
            if model.count == 0 {
                tblList.isHidden=false
            }
            
            self.view.addSubview(tblList)


        }
        if(textField.tag == 12){
            tblList.frame = CGRect(x: tffuletype.frame.origin.x, y: tffuletype.frame.origin.y + tffuletype.frame.size.height, width: tffuletype.frame.size.width, height: 200)
            Fuel = ["Petrol", "Desel", "CNG"]
            tblList.tag = textField.tag
            tblList.reloadData()
            tblList.isHidden=false
            self.view.addSubview(tblList)

        }


        return false
    }
    

    func GETBrands(){
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
        
        let url : String = String(format: "%@/GetBrandDistinct", AppDelegate.SharedInstance.URLAddress)

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
                    
                    if(self.brand.count==0)
                    {
                        self.tblList.isHidden=true
                        
                    }

                    
                case .success(let value):
                    
                    print(value)
                    let mydict = value as! Dictionary<String,Any>
                    
                    let myarray = mydict["brandList"] as! [Dictionary<String,Any>]
                    self.brand.removeAll()
                    for obj in myarray
                    {
                        self.brand .append(obj["brand"] as! String)
                    }
                    self.brand = self.brand.removingDuplicates()

                    print(mydict)
                    self.tblList.reloadData()
                    
                    if(self.brand.count==0)
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
    func GetModel(strBrand: String)
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
    let url = String(format: "%@/SelectModel/Brand=\"%@\"", AppDelegate.SharedInstance.URLAddress,strBrand)
    
    print(url)
    let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    
    Alamofire.request(urlString!, method: .get, parameters: nil, encoding: JSONEncoding.default)
    
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
                
                if(self.model.count==0)
                {
                    self.tblList.isHidden=true
                    
                }

                
            case .success(let value):
                
                print(value)
                let mydict = value as! Dictionary<String,Any>
                
                if mydict["modelList"] is [AnyHashable:Any] {
                    print("Yes, it's a Dictionary")
                    
                    
                    let dictmodel = mydict["modelList"] as! Dictionary<String,String>
                    self.model .append(dictmodel["model"]!)
                
                self.model = self.model.removingDuplicates()
                self.tblList.reloadData()
                if(self.model.count==0)
                {
                    self.tblList.isHidden=true
                }

                }
                
                guard mydict["modelList"] is [AnyHashable:Any] else {
                    print("No, it's not a Dictionary")
                    
                    let myarray = mydict["modelList"] as! [Dictionary<String,Any>]
                    self.model.removeAll()
                    for obj in myarray
                    {
                        self.model .append(obj["model"] as! String)
                    }
                    
                    self.model = self.model.removingDuplicates()
                    self.tblList.reloadData()
                    if(self.model.count==0)
                    {
                        self.tblList.isHidden=true
                        
                    }

                    return
                }
                
                

                print(mydict)
            }
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
        let url = String(format: "%@/Car/Info/mobile=\'%@\'", AppDelegate.SharedInstance.URLAddress,UserDefaults.standard.string(forKey: "UserID")!)
        
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
                        self.tfcarmake.text = mydict["carMake"] as? String
                        
                        if(self.tfcarmake.text == "null"){
                            self.tfcarmake.text = ""
                        }
                        self.tfcarmodel.text = mydict["carModel"] as? String
                        if(self.tfcarmodel.text == "null"){
                            self.tfcarmodel.text = ""
                        }
                        self.tffuletype.text = mydict["fuelType"] as? String
                        if(self.tffuletype.text == "null"){
                            self.tffuletype.text = ""
                        }
                    }
                }
        }
        
        }}
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {

        tblList.isHidden = true
        
    }

}

extension Array where Element: Hashable {
    
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

///////////////////////////////////////////////////////////
extension CarViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    

    
    @IBAction func OpenCamera(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        //  let frameSize: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width*0.5,y: UIScreen.main.bounds.size.height*0.5)
        
        // print out the image size as a test
        
        print(image.size)

//        let date = Date()
//        let calender = Calendar.current
//        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
//        let year = components.year
//        let month = components.month
//        let day = components.day
//        let hour = components.hour
//        let minute = components.minute
//        let second = components.second
//        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
//
//        self.Img.image =  self .textToImage(drawText: today_string, inImage: image, atPoint: CGPoint(x: 20, y: 20))
        
    }
    
//    @IBAction func save(_ sender: AnyObject) {
//        UIImageWriteToSavedPhotosAlbum(Img.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    
    
    func uploadImg(image: UIImage) {
        
       // let image = UIImage.init(named: "myImage")
        
        let imgData = image.jpegData(compressionQuality: 0.2)

        let url = "http://carokay.in:8082/D:/PulseLiveImages"
        let parameters = ["user":"Images", "password":"images@pulse"]

        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters
        },
                         to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value as Any )
                }
                upload.responseString { response in
                    print(response.result.value as Any )
                }

            case .failure(let encodingError):
                print(encodingError)
            }
        }

        
//        // User "authentication":
//           let parameters = ["user":"Images", "password":"images@pulse"]
//
//            // Image to upload:
//           let imageToUploadURL = Bundle.main.url(forResource: "userprofile", withExtension: "png")
//
//        // Server address (replace this with the address of your own server):
//
//         let url = "http://carokay.in:8082/D:/PulseLiveImages"
//
//             // Use Alamofire to upload the image
//             Alamofire.upload(
//                     multipartFormData: { multipartFormData in
//                             multipartFormData.append(imageToUploadURL!, withName: "9039358803")
//                             for (key, val) in parameters {
//                                     multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
//                                 }
//                     },
//                 to: url,
//                     encodingCompletion: { encodingResult in
//                         switch encodingResult {
//                         case .success(let upload, _, _):
//                             upload.responseJSON { response in
//                                 if let jsonResponse = response.result.value as? [String: Any] {
//                                     print(jsonResponse)
//                                 }
//                             }
//                         case .failure(let encodingError):
//                             print(encodingError)
//                         }
//                 }
//                 )
    }
}
