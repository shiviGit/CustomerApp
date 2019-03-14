//
//  ServicesViewController.swift
//  CustomerApp
//
//  Created by Apple on 22/01/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet var leadView: UIView!
    var window : UIWindow?
    
    
    
    var data: [MyModel]=[]
    @IBOutlet weak var collectionView: UICollectionView!
    public var collectionarray:NSArray = []
    public var collectionImgarray:NSArray = []
    public var readCountDict:NSDictionary = NSDictionary()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "MemeCell", bundle: nil), forCellWithReuseIdentifier: "MemeCell")
        collectionarray = ["Dent-Paint" , "Car-Servicing" , "Car-Cleaning" , "Car-Insurance" , "Car-Care" , "Tyre-Service" , "Car-Battery" , "Car-Inspection"]
        collectionImgarray = ["1" , "2" , "3" , "4" , "5" , "6" , "7" , "8"]
        print(  "my array is", collectionarray)
        print("unread count is",readCountDict)
        
        collectionView.backgroundColor = UIColor.lightGray
        NotificationCenter.default.addObserver(self, selector: #selector(helloReceived), name: NSNotification.Name("Hello"), object: nil)
    }
    
    @objc func helloReceived(notifiction: Notification){
        print(notifiction.object ?? "")
        let str =  (notifiction.object as? String)
        let ac = UIAlertController(title: "", message: str, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)

    }

    override func viewWillAppear(_ animated: Bool)
    {
        
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        self.viewDidLoad()
        
    }
//    @IBAction func ShowMenuDrawer(sender: UIButton)
//    {
//        slideMenuController()?.toggleLeft()
//    }
// navigation drawer as side menu controlling
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionarray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCell
        //let lblNotification = UILabel(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        let lblNotification = UILabel(frame: CGRect(x: 0, y: cell.frame.size.height-30, width: cell.frame.size.width, height: 30))
        lblNotification .textAlignment = NSTextAlignment.center
        //var MyValue = collectionarray .object(at: indexPath.row) as! Dictionary<String, Any>
        data = [MyModel(image: collectionImgarray .object(at: indexPath.row) as! String , name: collectionarray .object(at: indexPath.row) as! String),
        ]
        cell.configure(with: data[0])
        
        cell.backgroundColor = UIColor.white
        
        cell.contentView.addSubview(lblNotification)
        lblNotification.text = collectionarray .object(at: indexPath.row) as? String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var yourWidth = (collectionView.bounds.width/2 ) - 3
        let yourHeight = (collectionView.bounds.height/3 ) - 50
        
        if collectionarray.count % 2 == 0 {
            //even Number
        } else {
            // Odd number
            if indexPath.item == data.count-1
            {
                yourWidth = collectionView.bounds.width
            }
        }
        
        return CGSize(width: yourWidth, height: yourHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as! NextViewController
       // self.navigationController?.pushViewController(controller, animated: true)
        
        controller.strValue = (collectionarray .object(at: indexPath.row) as? String)!
        
        addChild(controller)
        controller.view.frame = self.view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            view.addSubview(controller.view)
        controller.didMove(toParent: self)

    }
}
