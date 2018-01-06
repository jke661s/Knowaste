//
//  PinAnnotation.swift
//  Knowaste
//
//  Created by Jiaqi Wang on 31/8/17.
//  Copyright © 2017 Jiaqi Wang. All rights reserved.
//

import UIKit
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
