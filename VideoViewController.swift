//
//  VideoViewController.swift
//  Knowaste
//
//  Created by Jiaqi Wang on 6/9/17.
//  Copyright © 2017 Jiaqi Wang. All rights reserved.
//

import UIKit
import CoreData

class VideoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var videoArray: [Video]?
    var URLs: [String] = []
    var refs: [String] = []
    var titles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVedioURL()
    }
    
    func fetchVedioURL(){
        let url = URL(string: "http://allrangenowaste.com/video.php")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print("Error")
            } else{
                if let content = data {
                    do{
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        self.videoArray = (myJson as! NSArray as! [Video])
                        for video in (self.videoArray as! [NSDictionary]){
                            let url = (video.object(forKey: "link") as! String)
                            self.refs.append((video.object(forKey: "link") as! String))
                            self.titles.append((video.object(forKey: "title") as! String))
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        cell.webView.allowsInlineMediaPlayback = true
        let videoURL = URLs[indexPath.row]
        cell.webView.loadHTMLString("<iframe width=\"\(cell.webView.frame.width)\" height=\"\(cell.webView.frame.height)\" src=\"\(videoURL)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        cell.titleLabel.text = titles[indexPath.row]
        cell.refLabel.text = "Original from: \(refs[indexPath.row])"
        
        return cell
    }

}
