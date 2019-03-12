//
//  ContactUsViewController.swift
//  CustomerApp
//
//  Created by Apple on 22/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit
import MapKit
class ContactUsViewController: UIViewController {

    @IBOutlet weak var lblmapLocation: LabelButton!
    
    @IBOutlet weak var lblMail: LabelButton!
    
    @IBOutlet weak var lblWhatsapp: LabelButton!
    
    @IBOutlet weak var lblCall: LabelButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblmapLocation.onClick = {self.goOnMap()}
        self.lblCall.onClick = {self.goOnCall()}
        self.lblMail.onClick = {self.goOnMail()}
        self.lblWhatsapp.onClick = {self.goOnWhatsApp()}

        
    }
    
    func goOnMap(){
        
        let coordinates = CLLocationCoordinate2DMake(18.538960,73.931870)
        
        let regionSpan =   MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "7th Floor, Office No-719, Tower II, WTC Kharadi, Pune, Maharashtra, 411014"
        
        mapItem.openInMaps(launchOptions:[
        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center)
        ] as [String : Any])

        
    }
    func goOnCall() {
        if let phoneCallURL = URL(string: "telprompt://\(+919860797979)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    func goOnMail() {
        let email = "support@carok.in"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func goOnWhatsApp() {
        //let phoneNumber =  "+919860797979"
        let appURL = NSURL(string: "whatsapp://send?phone=(+919860797979)")! // whatsapp://send?phone=(mobile number with country code)"
        //"whatsapp://?app"
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL as URL)
            }
        }
        else {
            // Whatsapp is not installed
            print("not installed")
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
