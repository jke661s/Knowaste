//
//  ViewController.swift
//  wasteCollection
//
//  Created by WUJINLANG on 19/9/17.
//  Copyright © 2017 WUJINLANG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var summaryTable: UITableView!
    var fetchedSummary = [Summary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        summaryTable.dataSource = self
        summaryTable.layer.borderWidth = 2.0
        parseData()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return fetchedSummary.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = summaryTable.dequeueReusableCell(withIdentifier: "cell")
        //cell?.textLabel?.font = [UIFont familyNames:"Chalkboard SE"]
       // cell?.detailTextLabel?.font = [UIFont .fontNames(forFamilyName: "Chalkboard SE")]
        //cell?.textLabel?.text = fetchedSummary[indexPath.row].date
        let dateString = fetchedSummary[indexPath.row].date
        cell?.textLabel?.text = dateString.substring(with:dateString.index(dateString.startIndex, offsetBy:0 )..<dateString.index(dateString.startIndex, offsetBy:9+1 ))
        cell?.detailTextLabel?.text = fetchedSummary[indexPath.row].residential
        return cell!
    
    }

    func parseData() {
        //in case the data is empty
        fetchedSummary = []
        let url = "https://data.melbourne.vic.gov.au/resource/sxp2-bzk2.json"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let configuration = URLSessionConfiguration.default
        let session = URLSession (configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("Error")
            }
            else{
                do{
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    // change the time format

                    //print(fetchedData)
                    for eachFetchedSummary in fetchedData{
                        let eachDate = eachFetchedSummary as! [String: Any]
                        let date = eachDate["date"] as! String
                        let residential = eachDate["residential"] as! String
                        
                        self.fetchedSummary.append(Summary(date: date , residential: residential))
                    
                    }
                    //print(self.fetchedSummary)
                    self.summaryTable.reloadData()
                    
                }
                catch {
                    print("Other Errors")
                }
            }
        }
        task.resume()
    }
}
//data and residential data
class Summary{
    
    var date: String
    var residential: String
    init(date : String, residential: String) {
        self.date = date
        self.residential = residential
    }

}

