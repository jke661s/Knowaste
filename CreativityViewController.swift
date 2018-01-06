//
//  CreativityViewController.swift
//  Knowaste
//
//  Created by Jiaqi Wang on 18/9/17.
//  Copyright © 2017 Jiaqi Wang. All rights reserved.
//

import UIKit
import CoreData

class CreativityViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var creativityArray: [Creativity]?
    var URLs: [String] = []
    var refs: [String] = []
    var titles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVedioURL()
    }
    
    func fetchVedioURL(){
        let url = URL(string: "http://allrangenowaste.com/creative.php")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print("Error")
            } else{
                if let content = data {
                    do{
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        self.creativityArray = (myJson as! NSArray as! [Creativity])
                        for creativity in (self.creativityArray as! [NSDictionary]){
                            let url = (creativity.object(forKey: "reference") as! String)
                            self.refs.append((creativity.object(forKey: "reference") as! String))
                            self.titles.append((creativity.object(forKey: "name") as! String))
                            self.URLs.append(url)
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    } catch{
                        print("ERROR")
                    }
                }
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return URLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreativityCollectionViewCell", for: indexPath) as! CreativityCollectionViewCell
        cell.webView.allowsInlineMediaPlayback = true
        let videoURL = URLs[indexPath.row]
        cell.webView.loadHTMLString("<iframe width=\"\(cell.webView.frame.width)\" height=\"\(cell.webView.frame.height)\" src=\"\(videoURL)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        cell.titleLabel.text = titles[indexPath.row]
        cell.refLabel.text = "Original from: \(refs[indexPath.row])"
        
        return cell
    }
    
}
