//
//  StudyCardViewController.swift
//  Knowaste
//
//  Created by Jiaqi Wang on 6/9/17.
//  Copyright © 2017 Jiaqi Wang. All rights reserved.
//

import UIKit

class StudyCardViewController: UIViewController {

    
    @IBOutlet weak var myImageView: UIImageView!
    var allCatArray: [Cat]?
    var catList: [NSDictionary] = []
    var cat: NSDictionary?
    @IBOutlet weak var myImage: UIImageView!
    var quizList: [Quiz] = []
    var quizExplan: [String] = []
    
    override func viewDidLoad() {
        fetchData()
        super.viewDidLoad()
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
                        self.loadImage()
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
            let catg = (self.catList[number].object(forKey: "sorting") as! String)
            switch (catg)
            {
            case "landfill": self.myImageView.image = UIImage(named: "landfill bin")
            case "recyclable": self.myImageView.image = UIImage(named: "recycle bin")
            case "compost": self.myImageView.image = UIImage(named: "compost bin")
            default : self.myImageView.image = UIImage(named: "loading")
            }
        }
        
    }
    

    @IBAction func addPage(_ sender: Any) {
        
        loadImage()
        
    }

    @IBAction func minusPage(_ sender: Any) {
        loadImage()
       
    }

}
