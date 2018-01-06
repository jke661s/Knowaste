//
//  HomeViewController.swift
//  Knowaste
//
//  Created by Jiaqi Wang on 17/8/17.
//  Copyright © 2017 Jiaqi Wang. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var buttonTwoWidth: NSLayoutConstraint!
    
    @IBOutlet weak var buttonThreeHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonThreeWidth: NSLayoutConstraint!
    
    @IBOutlet weak var buttonTwoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonFourWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonFourHeight: NSLayoutConstraint!
    
    @IBOutlet weak var videoView: UIWebView!
    
    @IBOutlet weak var buttonOneHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonOneWidth: NSLayoutConstraint!
    
    var images = ["one", "two", "three", "four"]
    
    var donateDisplayTimes = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let iconSize = UIScreen.main.bounds.width/2 - 39
        buttonTwoWidth.constant = iconSize
        buttonTwoHeight.constant = iconSize
        buttonOneWidth.constant = iconSize
        buttonOneHeight.constant = iconSize
        buttonThreeWidth.constant = iconSize
        buttonThreeHeight.constant = iconSize
        buttonFourWidth.constant = iconSize
        buttonFourHeight.constant = iconSize
        videoView.allowsInlineMediaPlayback = true
        videoView.loadHTMLString("<iframe width=\"\(videoView.frame.width)\" height=\"\(videoView.frame.height)\" src=\"https://www.youtube.com/embed/TjnNOCbuoCA?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "donate"){
            let controller = segue.destination as! DonateViewController
            controller.displayTimes = donateDisplayTimes + 1
            donateDisplayTimes = donateDisplayTimes + 1
        }
    }




    
}

