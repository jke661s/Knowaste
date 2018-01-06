//
//  PreDonateViewController.swift
//  Knowaste
//
//  Created by Jiaqi Wang on 5/10/17.
//  Copyright © 2017 Jiaqi Wang. All rights reserved.
//

import UIKit

class PreDonateViewController: UIViewController {

    
    var donateDisplayTimes = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "donate"){
            let controller = segue.destination as! DonateViewController
            controller.displayTimes = donateDisplayTimes + 1
            donateDisplayTimes = donateDisplayTimes + 1
        }
    }

}
