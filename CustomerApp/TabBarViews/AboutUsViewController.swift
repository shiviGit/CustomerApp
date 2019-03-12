//
//  AboutUsViewController.swift
//  CustomerApp
//
//  Created by Apple on 22/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit
import Foundation
class AboutUsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //textView.sizeToFit()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        textView.text = "CarOK is an on-demand car care marketplace, currently serving more than 15000 customers in Pune city. CarOK mission is to bring trust, convenience and transparency to the unorganized car care sector in India. Our team of service advisors personally inspect the car, get customers the lowest quotes from CarOk's network of carefully vetted garages, pickup-drop the car and supervise the work done at the garage."
        
        textView.font = .systemFont(ofSize: 25)
        
//                    textView.layer.borderWidth = 1
//                    textView.layer.borderColor = UIColor .lightGray.cgColor
                    textView.backgroundColor = .clear

       // self.updateTextFont(textView: textView)
        }
    
    
    func updateTextFont(textView: UITextView) {
        if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize.zero)) {
            return
        }
        let textViewSize = textView.frame.size
        let fixedWidth = textViewSize.width
        let expectSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        var expectFont = textView.font;
        if (expectSize.height > textViewSize.height) {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                textView.font = expectFont
            }
        }
        else {
            while (textView.sizeThatFits(CGSize(width: fixedWidth,height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textView.font
                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
            }
            textView.font = expectFont
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
