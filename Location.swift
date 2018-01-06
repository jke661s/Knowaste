//
//  Location.swift
//  Knowaste
//
//  Created by Jiaqi Wang on 31/8/17.
//  Copyright © 2017 Jiaqi Wang. All rights reserved.
//

import UIKit

class Location: NSObject {
    var locationId: Int
    var name: String
    var phone: String
    var postCode: Int
    var street: String
    var suburb: String
    
    init(locationId: Int, name: String, phone: String, postCode: Int, street: String, suburb: String){
        self.locationId = locationId
        self.name = name
        self.phone = phone
        self.postCode = postCode
        self.street = street
        self.suburb = suburb
    }
}
