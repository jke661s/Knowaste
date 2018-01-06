//
//  BinViewController.swift
//  Knowaste
//
//  Created by Jiaqi Wang on 19/8/17.
//  Copyright © 2017 Jiaqi Wang. All rights reserved.
//

import UIKit
import AVFoundation

class BinViewController: UIViewController {

    var player:AVAudioPlayer = AVAudioPlayer()
    var allCatArray: [Cat]?
    var catList: [NSDictionary] = []
    @IBOutlet weak var ldf: UIButton!
    @IBOutlet weak var myImage: UIImageView!
    var ldfloc: CGRect?
    var imageloc: CGRect?
    var cat: NSDictionary?
    @IBOutlet weak var scoreLabel: UILabel!
    var yesNo: Int = 0
//    var noNo: Int = 0
    var doneNo: Int = 0
    
    @IBOutlet weak var realScoreLabel: UILabel!
    @IBOutlet weak var scoreView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        imageloc = myImage.frame
        ldfloc = ldf.frame
        self.scoreView.isHidden = true

        
    }
    @IBAction func restart(_ sender: Any) {
        self.doneNo = 0
        self.scoreLabel.text = "\(self.doneNo + 1)/10"
        self.yesNo = 0
        self.scoreView.isHidden = true
    }
    

    
    func playYes(){
        do{
        let path = Bundle.main.path(forResource: "yes", ofType: "m4a")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: path!) as URL)
        } catch{
            //process error
        }
        player.play()
    }
    
    func playNo(){
        do{
            let path = Bundle.main.path(forResource: "no", ofType: "m4a")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: path!) as URL)
        } catch{
            //process error
        }
        player.play()
    }
    
    
    func fetchData(){
        let url = URL(string: "http://allrangenowaste.com/category.php")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print("Error")
            } else{
                if let content = data {
                    do{
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        self.allCatArray = (myJson as! NSArray as! [Cat])
                        for cat in (self.allCatArray as! [NSDictionary]){
                                self.catList.append(cat)
                        }
                        self.myImage.image = UIImage(named: "default")
                        DispatchQueue.main.async {
                            let number = Int(arc4random_uniform(UInt32(self.catList.count)))
                            self.cat = self.catList[number]
                            self.myImage.image = UIImage(named: "default")
                            self.myImage.loadImageUsingCacheWithURLString(URLString: self.cat?.object(forKey: "link") as! String)
                        }
                    } catch{
                        print("ERROR")
                    }
                }
            }
        }
        task.resume()
    }
    
    func loadImage() {
        let number = Int(arc4random_uniform(UInt32(self.catList.count)))
        cat = self.catList[number]
        self.myImage.image = UIImage(named: "default")
        DispatchQueue.main.async {
            self.myImage.loadImageUsingCacheWithURLString(URLString: self.cat?.object(forKey: "link") as! String)
        }
        
    }
    
    @IBAction func recycleTapped(_ sender: Any) {
        
        if (self.myImage.image == nil){
            return
        }
        
        if (self.myImage.image == UIImage(named: "default")){
            print("PLease wait")
        } else{
            UIView.animate(withDuration: 1, animations: {
                self.myImage.frame = CGRect(x: ((self.imageloc?.midX)! + 120), y:  ((self.imageloc?.midY)! + 237), width: 0, height: 0)
            }, completion: nil)
            
            self.doneNo = self.doneNo + 1
            
            if ((cat?.object(forKey: "sorting" ) as! String) == "recyclable") {
                self.yesNo = self.yesNo + 1
                playYes()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.myImage.frame = CGRect(origin: self.imageloc!.origin, size: self.imageloc!.size)
                    self.loadImage()
                    self.scoreLabel.text = "\(self.doneNo + 1)/10"
                }
            } else {
                playNo()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.myImage.frame = CGRect(origin: self.imageloc!.origin, size: self.imageloc!.size)
                    self.loadImage()
                    self.scoreLabel.text = "\(self.doneNo + 1)/10"
                }
            }

        }
        
        if (doneNo == 10){
            self.scoreView.isHidden = false
            self.realScoreLabel.text = "\(yesNo) answers correct!"
        }
        
    }
    
    
    
    @IBAction func compostTapped(_ sender: Any) {
        
        if (self.myImage.image == nil){
            return
        }
        
        if (self.myImage.image == UIImage(named: "default")){
            print("PLease wait")
        } else{
            UIView.animate(withDuration: 1, animations: {
                self.myImage.frame = CGRect(x: ((self.imageloc?.midX)!), y:  ((self.imageloc?.midY)! + 237), width: 0, height: 0)
            }, completion: nil)
            self.doneNo = self.doneNo + 1
            if ((cat?.object(forKey: "sorting" ) as! String) == "compost") {
                self.yesNo = self.yesNo + 1
                playYes()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.myImage.frame = CGRect(origin: self.imageloc!.origin, size: self.imageloc!.size)
                    self.loadImage()
                    self.scoreLabel.text = "\(self.doneNo + 1)/10"

                }
            } else {
                playNo()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.myImage.frame = CGRect(origin: self.imageloc!.origin, size: self.imageloc!.size)
                    self.loadImage()
                    self.scoreLabel.text = "\(self.doneNo + 1)/10"

                }
            }

            if (doneNo == 10){
                self.scoreView.isHidden = false
                self.realScoreLabel.text = "\(yesNo) answers correct!"
            }
        }


    }
    @IBAction func landfillTapped(_ sender: Any) {
        
        if (self.myImage.image == nil){
            return
        }
        if (self.myImage.image == UIImage(named: "default")){
            print("PLease wait")
        } else{
            UIView.animate(withDuration: 1, animations: {
                self.myImage.frame = CGRect(x: ((self.imageloc?.midX)! - 120), y:  ((self.imageloc?.midY)! + 237), width: 0, height: 0)
            }, completion: nil)
            self.doneNo = self.doneNo + 1

            if ((cat?.object(forKey: "sorting" ) as! String) == "landfill") {
                self.yesNo = self.yesNo + 1

                playYes()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.myImage.frame = CGRect(origin: self.imageloc!.origin, size: self.imageloc!.size)
                    self.loadImage()
                    self.scoreLabel.text = "\(self.doneNo + 1)/10"

                }
            } else {
                playNo()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.myImage.frame = CGRect(origin: self.imageloc!.origin, size: self.imageloc!.size)
                    self.loadImage()
                    self.scoreLabel.text = "\(self.doneNo + 1)/10"
                }
            }
            
        }
    }
}
